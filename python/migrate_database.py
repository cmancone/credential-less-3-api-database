# This script is designed to be called by either the lambda or a developer locally.
# However, lambdas tend to complain when a file starts with a #! directive, so don't use one of those here.
# Instead, you have to call it from python when running locally: `python migrate_database.py`
import clearskies
import clearskies_aws


# this is the entry point for our lambda
def lambda_handler(event, context):
    # Build our application, which is just going to be the mygration handler, which will perform our migration.
    # We will tell the migration handler to allow input, which means that it accepts a database schema as input
    # from the client and applies it to the database.  This can be quite dangerous, depending on the context,
    # but we're going to wrap it up in a lambda invocation context.  This means that it not exposed as an endpoint
    # anywhere, but can only be executed by someone who has the appropriate permissions in AWS.  This
    # makes it quite safe (assuming we setup our AWS permissions appropriately).
    migration_app = clearskies.Application(
        clearskies.handlers.Mygrations,
        {'allow_input': True}
    )

    # here we'll attach our migration application to a lambda invocation context (which just our way of
    # telling clearskies that it is going to be executed directly inside a lambda). We tell it to fetch database
    # credentials out of an AKeyless dynamic producer. It also needs to know the path to the dynamic producer
    # where it will get database credentials, and the location of the database server. Both are passed
    # to clearskies as environment variables stored in the Lambda by terraform, so you don't see them here.
    # Finally we'll tell it to connect to AKeyless via IAM auth, and it fetches the access id from
    # another environment variable set in the Lambda
    migrate = clearskies_aws.contexts.lambda_invocation(
        migration_app,
        additional_configs=[
            clearskies.secrets.additional_configs.mysql_connection_dynamic_producer(),
            clearskies.secrets.akeyless_aws_iam_auth(),
        ]
    )
    return migrate(event, context)

# and this is the entry point for our developers.  We would call it with something like this:
# python3 migrate_database --environment production --command plan
if __name__ == '__main__':
    # Developers need to do things much differently.  We're obviously not running in a Lambda.  Instead we
    # will be run from the command line.  In addition, we can fetch the latest schema out of the SQL folder
    # instead of passing it directly as input.  We do still need some input though, since we need to
    # specify the command to run (check, plan, apply, etc...)
    migration_app = clearskies.Application(
        clearskies.handlers.Mygrations,
        {
            'sql': '../sql/',
            'allow_input': True,
        },
    )

    # We still need to connect to the database, which means an AKeyless dynamic producer.  However,
    # developers probably won't connect to AKeyless via AWS IAM auth.  Instead, they will be using SAML.
    # We also need to connect to the database which, for a developer, means that we need to use the bastion.
    # Like always, we need to know the host name of the database and the path to the dynamic producer
    # to get credentials from.  For a developer, these things are best fetched from an environment-specific
    # configuration file, and then we just tell AKeyless which environment we're running against.
    migrate = clearskies.contexts.cli(
        migration_app,
        additional_configs=[
            clearskies.secrets.additional_configs.mysql_connection_dynamic_producer_via_ssh_cert_bastion(),
            clearskies.secrets.akeyless_access_key_auth(),
        ]
    )
    migrate()
