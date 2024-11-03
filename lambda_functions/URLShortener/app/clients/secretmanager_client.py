import boto3
import json

class SecretsManagerClient:
    def __init__(self):
        self.client = boto3.client('secretsmanager', region_name='us-east-1')

    def get_secrets(self):
        secret_name = 'urlshortener/api-keys'
        response = self.client.get_secret_value(SecretId=secret_name)
        secret = response['SecretString']
        return json.loads(secret)