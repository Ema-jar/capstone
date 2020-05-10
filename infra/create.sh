#!/bin/bash

check_stack()
{
    echo "Checking status for: $1"

    while true; do
        sleep 5
        current_status=$(aws cloudformation describe-stacks --stack-name $1 | jq '.Stacks[0].StackStatus')

        current_status="${current_status%\"}"
        current_status="${current_status#\"}"

        echo "Current status: ${current_status}"

        if [ "$current_status" = "CREATE_COMPLETE" ]; then
            echo "$1 created"
            return 0
        fi
    done
}

create_network()
{
    aws cloudformation create-stack --stack-name network --template-body file://network.yml  --parameters file://network.json --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=us-west-2

    check_stack "network"

}

crete_service()
{
    aws cloudformation create-stack --stack-name service --template-body file://service.yml  --parameters file://service.json --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=us-west-2

    check_stack "service"
}



if [[  ( $1 == "network" || -z "$1" ) ]];
then
    create_network
fi
if [[  ( $1 == "service" || -z "$1" ) ]];
then
    crete_service
fi

