#!/bin/bash

DIR=$( pwd )
ENV=$1
ACTION=$2
TARGETMODULE=$3

function show_usage {
    echo  'Error: Usage ./bin/deploy.sh [Environment] [plan|apply|destroy] [Optional module name inside quotation marks]'
    echo  'Get plan state        = ./bin/deploy.sh [Environment] plan ["module name]"'
    echo  'Apply single module   = ./bin/deploy.sh dev apply "module.lambda_function"'
    echo  'Apply enrire stack    = ./bin/deploy.sh dev apply'
}

function apply {
    cd ${DIR}/terraform/stacks/$ENV
    rm -rf .terraform .terraform.lock.hcl
    ln -sf "${DIR}/secrets/$ENV/s3_backend.tf"  "./s3_backend.tf"
    ln -sf "${DIR}/secrets/$ENV/terraform.auto.tfvars"  "./terraform.auto.tfvars"
    terraform --version | grep `cat .tfenv-version` # Make sure to use repository defined TF version (tfenv)
    terraform init
    [[ -z "$TARGETMODULE" ]] &&  terraform apply
    [[ ! -z "$TARGETMODULE" ]] &&  terraform apply -target="${TARGETMODULE}"

    [[ $? -eq 1 ]] && exit 0
}

function plan {
    cd ${DIR}/terraform/stacks/$ENV
    rm -rf .terraform .terraform.lock.hcl
    ln -sf "${DIR}/secrets/$ENV/s3_backend.tf"  "./s3_backend.tf"
    ln -sf "${DIR}/secrets/$ENV/terraform.auto.tfvars"  "./terraform.auto.tfvars"
    terraform --version | grep `cat .tfenv-version` # Make sure to use repository defined TF version (tfenv)
    terraform init
    [[ -z "$TARGETMODULE" ]] &&  terraform plan
    [[ ! -z "$TARGETMODULE" ]] &&  terraform plan -target="${TARGETMODULE}"

    [[ $? -eq 1 ]] && exit 0
}

function destroy {
    cd ${DIR}/terraform/stacks/$ENV
    rm -rf .terraform .terraform.lock.hcl
    ln -sf "${DIR}/secrets/$ENV/s3_backend.tf"  "./s3_backend.tf"
    ln -sf "${DIR}/secrets/$ENV/terraform.auto.tfvars"  "./terraform.auto.tfvars"
    terraform --version | grep `cat .tfenv-version` # Make sure to use repository defined TF version (tfenv)
    terraform init
    [[ -z "$TARGETMODULE" ]] &&  terraform destroy
    [[ ! -z "$TARGETMODULE" ]] &&  terraform destroy -target="${TARGETMODULE}"

    [[ $? -eq 1 ]] && exit 0
}

function execute {
    [[ $ACTION == "plan" ]] && plan
    [[ $ACTION == "apply" ]] && apply
    [[ $ACTION == "destroy" ]] && destroy
}

[[ $# -ne 2 ]] && [[ $# -ne 3 ]] && show_usage

execute $ENV $ACTION $TARGETMODULE