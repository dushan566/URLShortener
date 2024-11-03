from app.handlers.url_shortener import lambda_handler

def handler(event, context):
    return lambda_handler(event, context)