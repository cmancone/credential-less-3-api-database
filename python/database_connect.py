#!/usr/bin/env python3
import clearskies
import clearskies_aws


if __name__ == '__main__':
    database_connect = clearskies.contexts.cli(
        {
            'handler_class': clearskies.handlers.DatabaseConnector,
            'handler_config': {},
        },
        di_class=clearskies_aws.di.StandardDependencies,
        additional_configs=[
            clearskies_aws.secrets.additional_configs.mysql_connection_dynamic_producer_via_ssh_cert_bastion(),
            clearskies.secrets.akeyless_access_key_auth(),
        ]
    )
    database_connect()
