module "acm_certificate" {
 source = "../../modules/acm_certificate"
 domain_name       = "short.dushanwijesinghe.com"
 route53_zone_id   = var.route53_zone_id
 tags              = local.tags
}

module "dynamodb" {
 source = "../../modules/dynamodb"
 application_name = local.application_name
 tags             = local.tags
}

module "api_keys_secret" {
 source = "../../modules/secret_manager"
 application_name = local.application_name
 secret_value     = jsonencode({"apiUser" = "${var.api-user}", "apiKey" = "${var.api-key}"})
 tags             = local.tags
}

module "iam_role" {
  source = "../../modules/iam_role"
  name                    = local.application_name
  aws_managed_policy_arns = []
  assume_role_policy      = data.aws_iam_policy_document.lambda_assume_role_policy.json
  custom_policies         = [
    data.aws_iam_policy_document.cloudwatch_logging_policy.json,
    data.aws_iam_policy_document.secrets_manager_policy.json,
    data.aws_iam_policy_document.dynamodb_policy.json
    ]
  tags                    = local.tags
}

module "lambda_function" {
  source = "../../modules/lambda_function"
  function_name    = local.application_name
  handler          = "lambda_function.lambda_handler"
  source_code_path = "../../../lambda_functions/URLShortener"
  role_arn         = module.iam_role.arn
  source_path      = "./lambda-module/code"
  publish          = true
  runtime          = "python3.11"
  memory_size      = 128
  timeout          = 4
  depends_on       = [module.iam_role]
  tags             = local.tags
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  application_name         = local.application_name
  domains                  = ["short.dushanwijesinghe.com"]
  origin_domain            = "short.dushanwijesinghe.com"
  lambda_at_edge           = true
  lambda_arn               = "${module.lambda_function.lambda_arn}:${module.lambda_function.version}"
  acm_certificate_arn      = module.acm_certificate.arn
  depends_on               = [module.lambda_function, module.acm_certificate]
  tags                     = local.tags
}