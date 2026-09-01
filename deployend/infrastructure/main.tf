locals {
  fe_tmp_server = jsondecode(
    file("${path.module}/../.fe_tmp_sv_outputs.json")
  )

  config = jsondecode(
    file("${path.root}/../../recall_config.json")
  )
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "bastion_server" {
  source = "./modules/bastion_server"

  security_group_ids      = [module.security_groups.bastion_host_sg]
  public_subnet_id        = module.vpc.public_subnet_d1_id
  bastion_key_name        = var.bastion_key_name
  bastion_public_key_name = file(var.bastion_public_key_path)
}

module "backend_server" {
  source = "./modules/be_server"
  ami = module.frontend_launch_template.backend_ami_id
  security_group_ids      = [module.security_groups.backend_sg]
  private_subnet_id       = module.vpc.private_subnet_a1_id
  backend_key_name        = var.backend_key_name
  backend_public_key_name = file(var.backend_public_key_path)
}


module "frontend_launch_template" {
  source = "./modules/fe_launch_template"

  vpc_id                   = module.vpc.vpc_id
  frontend_instance_id     = local.fe_tmp_server.tmp_frontend_instance_id.value
  security_group_ids       = [module.security_groups.frontend_sg]
  frontend_key_name        = var.frontend_key_name
  frontend_public_key_name = file(var.frontend_public_key_path)
  backend_instance_id      = local.fe_tmp_server.tmp_backend_instance_id.value

}


module "alb" {
  source = "./modules/alb" 
 
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids  = [module.vpc.private_subnet_b1_id, module.vpc.private_subnet_c1_id]
  launch_template_id = module.frontend_launch_template.launch_template_id
  security_group_id  = module.security_groups.alb_sg 
  public_subnet_ids = [module.vpc.public_subnet_b1_id, module.vpc.public_subnet_c1_id]
}

module "api_gateway" {
  source = "./modules/api_gateway" 
 
  target_backend_instance_id             = module.backend_server.recall_backend_instance_id
  private_subnet_ids                     = [module.vpc.private_subnet_b1_id, module.vpc.private_subnet_a2_id]
  internal_security_group_id             = module.security_groups.internal_alb_sg
  vpc_id                                 = module.vpc.vpc_id
}

module "ssl_cert" {
  source = "./modules/ssl_certificate"

  domain_name = local.config.deployend.domain_name
}

module "domain_mgt" {
  source = "./modules/domain_mgt" 
  
  hosted_zone_name          = local.config.deployend.existing_route53_public_hosted_zone
  domain_validation_options = module.ssl_cert.domain_validation_options

  cloudfront_domain_name = module.cloudfront.distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id
  certificate_arn = module.ssl_cert.certificate_arn
  internal_alb_dns_name = module.api_gateway.internal_alb_dns_name
  internal_alb_zone_id = module.api_gateway.internal_alb_zone_id
  vpc_id = module.vpc.vpc_id 
}

module "cloudfront" {
  source = "./modules/cloudfront"

  acm_certificate_arn = module.domain_mgt.validated_certificate_arn
  origin_domain_name  = module.alb.alb_dns_name
}