output "woooba_non-prod_vpc_id" {
  value = module.vpc.vpc_id
  description = "vpc id of the non-prod woooba vpc"
}