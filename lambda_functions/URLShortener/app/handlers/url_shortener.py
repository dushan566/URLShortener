import json
import urllib.parse
import hashlib
from app.classes.app import URLShortenerApp

app = URLShortenerApp()

def lambda_handler(event, context):
    try:
        request = event['Records'][0]['cf']['request']

        # Get the query string
        query_string = request.get('querystring', '')

        # Extract the CloudFront request's domain name
        short_domain = request['headers'].get('host', [{'value': ''}])[0]['value']
        
        # Parse query string parameters
        params = dict(urllib.parse.parse_qsl(query_string))

        # Extract required parameters (handle potential missing keys)
        api_key  = params.get('apiKey')
        api_user = params.get('apiUser')
        long_url = params.get('longUrl')

        # Check whether user acceess v1 endpoint
        if request['uri'] == '/v1/shorten/' or request['uri'] == '/v1/shorten' or request['uri'] == '/v1/':
            # Check whether URL query string parameters are missing
            if None in (api_key, api_user, long_url):
                response = {
                    'status': '400',
                    'headers': {
                        "content-type": [
                            {
                                'key': 'Content-Type',
                                'value': 'application/json'
                            }
                        ]
                    },
                    'body': json.dumps({
                        "error": "URL query string required: shorten?, apiKey, apiUser, and longUrl",
                        "example": f"https://{short_domain}/v1/shorten?apiKey=[key]&apiUser=[apiUser]&longUrl=[longUrl]"
                    }, indent=2)
                }
                # Return status 400 user input error
                return response
            
            # Check authentication
            if api_key != app.api_key or api_user != app.api_user:
                response = {
                    'status': '401',
                    'headers': {
                        "content-type": [
                            {
                                'key': 'Content-Type',
                                'value': 'application/json'
                            }
                        ]
                    },
                    # Deny unauthotized users 
                    'body': json.dumps({"error": "Unauthorized"})
                }
                return response
            
            # Check if the long URL already has a short URL
            short_url = app.get_existing_short_url(long_url)

            # Return already available record information
            if short_url:
                output_data = {
                    "data": {
                        'long_url': long_url,
                        'url': short_url,
                        'hash': short_url.split('/')[-1],
                        'global_hash': short_url.split('/')[-1],
                        'new_hash': 0   
                        },
                    "status_code": 200,
                    "status_message": "success"
                }
            else:
                # Generate a short URL
                short_hash = hashlib.sha1(long_url.encode()).hexdigest()[:5]
                short_url = f"https://{short_domain}/{short_hash}"
                # Write new record into DynamoDB
                app.store_url(short_url, long_url)

                # Output new record information
                output_data = {
                    "data": {
                        'long_url': long_url,
                        'url': short_url,
                        'hash': short_url.split('/')[-1],
                        'global_hash': short_url.split('/')[-1],
                        'new_hash': 1   
                        },
                    "status_code": 200,
                    "status_message": "success"
                }
            # Generate response for existing/new record information (Lambda format)
            response = {
                'status': '200',
                'headers': {
                    "content-type": [
                        {
                            'key': 'Content-Type',
                            'value': 'application/json'
                        }
                    ]
                },
                'body': json.dumps(output_data, indent=2)
            }
            # Return existing/new record information
            return response
        
        uri = request['uri'].lstrip('/')
        short_url = f"https://{short_domain}/{uri}"
        long_url = app.get_long_url(short_url)
        
        if long_url:
            response = {
                'status': '302',
                'statusDescription': 'Found',
                'headers': {
                    'location': [{
                        'key': 'Location',
                        'value': long_url
                    }]
                }
            }
        else:
            response = {
                'status': '404',
                'statusDescription': 'Not Found',
                'headers': {
                    'content-type': [{
                        'key': 'Content-Type',
                        'value': 'application/json'
                    }]
                },
                'body': json.dumps({"error": "Short URL not found"})
            }

        return response

    except KeyError as e:
        response = {
            'status': '400',
            'statusDescription': 'Bad Request',
            'headers': {
                'content-type': [{
                    'key': 'Content-Type',
                    'value': 'application/json'
                }]
            },
            'body': json.dumps({"error": f"Invalid event structure: {str(e)}"})
        }
        return response

    except Exception as e:
        response = {
            'status': '500',
            'statusDescription': 'Internal Server Error',
            'headers': {
                'content-type': [{
                    'key': 'Content-Type',
                    'value': 'application/json'
                }]
            },
            'body': json.dumps({"error": str(e)})
        }
        return response