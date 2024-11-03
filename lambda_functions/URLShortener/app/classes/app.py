from app.clients.dynamodb_client import DynamodbClient
from app.clients.secretmanager_client import SecretsManagerClient

class URLShortenerApp:
    def __init__(self):
        self.db_client = DynamodbClient()
        self.secrets_client = SecretsManagerClient()
        self.secrets  = self.secrets_client.get_secrets()
        self.api_key  = self.secrets['apiKey']
        self.api_user = self.secrets['apiUser']

    def get_long_url(self, short_url):
        return self.db_client.get_long_url(short_url)

    def store_url(self, short_url, long_url):
        self.db_client.store_url(short_url, long_url)

    def get_existing_short_url(self, long_url):
        return self.db_client.get_existing_short_url(long_url)