output "bucket_domain_name" {
  value       = local.enabled ? join("", aws_s3_bucket.default[*].bucket_domain_name) : ""
  description = "FQDN of bucket"
}

output "bucket_regional_domain_name" {
  value       = local.enabled ? join("", aws_s3_bucket.default[*].bucket_regional_domain_name) : ""
  description = "The bucket region-specific domain name"
}

output "bucket_website_domain" {
  value       = join("", aws_s3_bucket_website_configuration.default[*].website_domain, aws_s3_bucket_website_configuration.redirect[*].website_domain)
  description = "The bucket website domain, if website is enabled"
}

output "bucket_website_endpoint" {
  value       = join("", aws_s3_bucket_website_configuration.default[*].website_endpoint, aws_s3_bucket_website_configuration.redirect[*].website_endpoint)
  description = "The bucket website endpoint, if website is enabled"
}

output "bucket_id" {
  value       = local.enabled ? join("", aws_s3_bucket.default[*].id) : ""
  description = "Bucket Name (aka ID)"
}

output "bucket_arn" {
  value       = local.enabled ? join("", aws_s3_bucket.default[*].arn) : ""
  description = "Bucket ARN"
}

output "bucket_region" {
  value       = local.enabled ? join("", aws_s3_bucket.default[*].region) : ""
  description = "Bucket region"
}

output "enabled" {
  value       = local.enabled
  description = "Is module enabled"
}

output "replication_role_arn" {
  value       = local.enabled && local.replication_enabled ? join("", aws_iam_role.replication[*].arn) : ""
  description = "The ARN of the replication IAM Role"
}