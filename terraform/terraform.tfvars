name   = "products"
region = "us-east-1"
vpc_id = "vpc-asdfer"

database_subnet_ids                   = ["subnet-private-1", "subnet-private-2", "subnet-private-3"]
database_bastion_subnet_id            = "subnet-public-1"
database_availability_zones           = ["us-east-1a", "us-east-1b", "us-east-1c"]
database_incoming_security_group_ids  = []
akeyless_access_id                    = "p-123456789012"
akeyless_gateway_domain               = "us.gateway.akeyless.example.com"
akeyless_folder                       = "/services/products/production"
application_lb_subnet_ids             = ["subnet-public-1", "subnet-public-2", "subnet-public-3"]
application_route_53_hosted_zone_name = "example.com"
application_domain_name               = "shopping.example.com"
