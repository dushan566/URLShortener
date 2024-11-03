import boto3

class DynamodbClient:
    def __init__(self):
        self.dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        self.table = self.dynamodb.Table('URLShortenerTable')

    def get_long_url(self, short_url):
        response = self.table.get_item(Key={'shortUrl': short_url})
        return response['Item']['longUrl'] if 'Item' in response else None

    def store_url(self, short_url, long_url):
        self.table.put_item(Item={'shortUrl': short_url, 'longUrl': long_url})

    def get_existing_short_url(self, long_url):
        response = self.table.query(
            IndexName='longUrl-index',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('longUrl').eq(long_url)
        )
        items = response.get('Items', [])
        return items[0]['shortUrl'] if items else None