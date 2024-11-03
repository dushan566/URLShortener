# URLShortener

URLShortener is a serverless application designed to create short URLs for long URLs provided by authenticated users. This application leverages AWS CloudFront@Edge, Lambda, DynamoDB, and AWS Secrets Manager to generate, store, and retrieve short URLs. The application uses API keys and user authentication for secure access to the URL shortening service.

## Architecture

This application is built using the following AWS services:
- **CloudFront@Edge**: Manages and distributes requests securely with low latency across the globe.
- **Lambda (Edge Functions)**: Provides custom logic to handle API requests and redirect short URLs to their original URLs.
- **DynamoDB**: A highly available NoSQL database that stores the mappings between long URLs and their generated short URLs.
- **Secrets Manager**: Securely stores API keys and other sensitive information.

## Features

- **URL Shortening**: Converts a long URL into a short, easy-to-share URL.
- **API Authentication**: Ensures that only authorized users can create short URLs.
- **Redirection**: Redirects short URLs to their original long URLs without requiring authentication.
- **Error Handling**: Returns an error message if a short URL does not exist.

## How It Works

1. **Creating a Short URL**:
   - Users send a `GET` request to the API endpoint:  
     ```
     https://<short_domain>/v1/shorten?apiKey=[apiKey]&apiUser=[apiUser]&longUrl=[longUrl]
     ```
   - The API validates the API key and user.
   - Upon successful authentication, the application generates a short URL for the provided long URL, stores it in DynamoDB, and returns the short URL.
   - Once the record is created, the API service will return the response below. If the short URL creation request is new, the response will include `new_hash: 1`. If the same URL is submitted and the record already exists in DynamoDB, the response will include `new_hash": 0`.
     ```
      {
       "data": {
         "long_url": "[longUrl]",
         "url": "https://<short_domain>/{short_hash}",
         "hash": "{short_hash}",
         "global_hash": "{short_hash}",
         "new_hash": 1
       },
       "status_code": 200,
       "status_message": "success"
      }
     ```

2. **Accessing a Short URL**:
   - Users can access the short URL by entering it in the browser:
     ```
     https://<short_domain>/{short_hash}
     ```
   - The application retrieves the long URL from DynamoDB based on the short hash and redirects the user to the long URL.
   - If the short URL does not exist in DynamoDB, it returns an error:
     ```json
     {"error": "Short URL not found"}
     ```

## API Endpoints

- **Shorten URL**:  
  - **Path**: `/v1/shorten`
  - **Method**: `GET`
  - **Parameters**:
    - `apiKey`: Your API key for authentication.
    - `apiUser`: Your API user identifier.
    - `longUrl`: The original URL that you want to shorten.
  - **Example**:  
    ```shell
    curl "https://<short_domain>/v1/shorten?apiKey=<apiKey>&apiUser=<apiUser>&longUrl=https://example.com"
    ```

- **Access Short URL**:
  - **Path**: `/{short_hash}`
  - **Method**: `GET`
  - **Description**: Redirects to the long URL associated with the short hash, or returns an error if not found.

## Provisioning the Serverless Application

To set up and deploy the URL Shortener application, follow these steps and ensure the necessary tools and configurations are in place.

 - ### Prerequisites

   1. **Terraform**: Install Terraform to manage infrastructure as code. Make sure `tfenv` is installed to easily select the correct Terraform version as specified in the repository settings.
   2. **AWS Access**: Ensure AWS access keys are configured on your local machine with the necessary permissions to deploy the resources.
   3. **Bash**: The provisioning process uses a Bash glue script to automate Terraform and other required actions.

- ### Environment Seup:
  Specify the deployment environment (e.g., dev, staging, prod).

- ### Terraform Actions: 
  Choose one of the following actions:
  - **plan**: Previews the changes to be made.
  - **apply**: Executes the changes to create or update resources.
  - **destroy**: Removes the provisioned resources.

- ### Managing Sensitive Data
  Sensitive values, such as API keys and secrets, are stored securely in the secrets folder. Ensure that this folder contains the necessary files in the correct formats. 
  
  Importantly, do not push the secrets folder to GitHub. The secrets folder is provided here only as a reference on how to structure sensitive information. These files should be stored securely in a vault, such as LastPass, or encrypted using a tool like git-crypt to protect sensitive data.

- ### Provisioning Steps

   This application uses an automated provisioning process driven by a Bash script. Simply use the following command to deploy, update, or destroy resources based on the desired environment.

   ```bash
     Syntax ./bin/deploy.sh [Environment] [plan|apply|destroy] [Optional module name inside quotation marks]
     Get plan state        = ./bin/deploy.sh [Environment] plan ["module name]"
     Apply single module   = ./bin/deploy.sh dev apply "module.lambda_function"
     Apply enrire stack    = ./bin/deploy.sh dev apply
   ```