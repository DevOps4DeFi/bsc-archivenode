output "access_url" {
  value       = "https://${aws_route53_record.bsc-archive.fqdn}" ## TODO change if we change to https
  description = "The base url to hit to access json-rpc"
}

