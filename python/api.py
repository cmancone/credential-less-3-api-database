import app
import clearskies
import clearskies_aws


# build our context outside of the lambda handler and AWS will cache it for us for better performance
api_in_lambda = clearskies_aws.contexts.lambda_elb(
    app.api,
    additional_configs=[
        clearskies.secrets.additional_configs.mysql_connection_dynamic_producer(),
        clearskies.secrets.akeyless_aws_iam_auth(),
    ],
)
def lambda_handler(event, context):
    return api_in_lambda(event, context)
