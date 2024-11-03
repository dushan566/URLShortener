# local_test.py
import json
from lambda_function import handler

event = {
    "Records": [
        {
            "cf": {
                "request": {
                    "uri": "/v1/shorten",
                    "querystring": "apiKey=yourkey&apiUser=youruser&longUrl=https://mylongdomain.example.com/mylongpath"
                }
            }
        }
    ]
}

context = {}  # Simulated context

response = handler(event, context)
print(json.dumps(response, indent=2))