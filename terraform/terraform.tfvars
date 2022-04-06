name   = "products"
region = "us-east-1"
vpc_id = "vpc-0bc92a5c9185a73be"

database_subnet_ids                   = ["subnet-0d5284d3206e5edfc", "subnet-0c37bd7b353a11892", "subnet-023cefae29dfc3a36"]
database_bastion_subnet_id            = "subnet-0b99bc55e7f0b0d24"
database_availability_zones           = ["us-east-1a", "us-east-1b", "us-east-1c"]
database_incoming_security_group_ids  = ["sg-0f89a11e2b89ad0b5"]
akeyless_access_id                    = "p-x93k1uragthy"
akeyless_folder                       = "/services/products/production"
akeyless_ca_public_key                = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCutBbTXAriqi4jkq1wkI2Z//ijzk0xXg5XfXAets3ux+ULGL4ECcEBn3wjdqarQo6MH7lrrvFBz93psMOqb4r3Q1maV25NJdilnPjSMkMEGRwfuxeVfXdFMRO1KpwpgDSzK7vDsuuX9+DKMYmVtenzzOCbZ4Mio5kZLR3hZqtDi/D6ZXrz185xC8pZN5cWhkyDplGEeaWg8giPpUUB1p07f4s3ogcWHv/6LEd2ULg5+qUc8qQ74MpZFa0n709N4W2Q+p8b45fon959AGpG0UJuk+qNSyNTEycIWAgZTKyReBu4GILc7jpuNFNycPQntHR+nAAe+el8DiFrCCwF2TVj"
application_lb_subnet_ids             = ["subnet-0b99bc55e7f0b0d24", "subnet-03f48eb08e94b0c75", "subnet-0d51a6f4b04c979a9"]
application_route_53_hosted_zone_name = "always-upgrade.us"
application_domain_name               = "products.always-upgrade.us"
