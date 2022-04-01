name         = "products"
region       = "us-east-1"
vpc_id       = "vpc-0bc92a5c9185a73be"
zip_filename = "python.zip"

database_subnet_ids                  = ["subnet-0d5284d3206e5edfc", "subnet-0c37bd7b353a11892", "subnet-023cefae29dfc3a36"]
database_bastion_subnet_id           = "subnet-0b99bc55e7f0b0d24"
database_availability_zones          = ["us-east-1a", "us-east-1b", "us-east-1c"]
database_incoming_security_group_ids = ["sg-0f89a11e2b89ad0b5"]
akeyless_api_host                    = "https://us.gateway.akeyless.always-upgrade.us"
akeyless_folder                      = "/services/products/production"
akeyless_ca_public_key               = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/71u8tJ1TrprN7eFlKTTTXR9DQf2aiEjRn5D/VmcqfPPX26YPgczfmd2dk1hZ8+zyE+DdbJpsN671ee9BgOoTzw+xK3vo5sC+81NvfkJeAkdwIl+dST6iw7ewbdNUe+CIWs7A4UjBWNhW4hMK4rLPZ3QLbCnBmQczbFJXzrYYYSAXd25vacwQLay7swQcDDrpm2D6m6940FQmoVxlKOHtoqbgsNAtqkQOzTMIYSBIi66hSGeAB9n+UOfvW0xv7yit1eFV+FoGjvL1XaetFOFZhtpKc96ZC/Rm+nX9NqdNoW5u0Sxc35QYyFvdDVwx6ev1YlTLb1J3JGVgZAirZhxJ"
