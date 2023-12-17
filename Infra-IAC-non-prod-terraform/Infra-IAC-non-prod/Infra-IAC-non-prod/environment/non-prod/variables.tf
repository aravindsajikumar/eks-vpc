variable "namespace" {
  default     = ""
  description = "The app/organization name given to create lable for the resources from label module "
}

variable "vpc_name" {
  default = "woooba-non-prod"
}

variable "stage" {
  default     = ""
  description = "The environment prefix name given to create lable for the resources from label module "
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "cidr_block" {
  default     = "10.1.0.0/16"
  description = "CIDR block for creating the VPC"
}

variable "enable_dns_hostnames" {
  default     = true
  description = "This variable is to enable/disable dns hostnames in VPC"
}

variable "enable_dns_support" {
  default     = true
  description = "This variable is to enable/disable dns support in VPC"
}

variable "enable_default_security_group_with_custom_rules" {
  default     = true
  description = "This variable is to enable the default security with custom rules in the VPC"
}

variable "availability_zones" {
  default     = ["us-east-1a","us-east-1b"]
  description = "This are the availability zones that we are creating the subnets and our aws resources are running"
}

variable "nat_gateways_count" {
  default     = 1
  description = "This variable is to restrict the creation of NAT gateways and override the default behaviour of VPC module which will create NAT gateways as per the AZ count"
}

variable "single_nat" {
  type        = bool
  default     = "true"
  description = "If set to 'true' a single nat g/w will be created for multiple subnets and the variable 'nat_gateways_count' will be ignored"
}

variable "create_default_security_group" {
  default     = true
  description = "This variable will enable the default security group in the VPC module"
}

variable "assign_eip_address" {
  default     = true
  description = "This variable is to disable or enable eip creation for the bastion/ec2"
}

variable "associate_public_ip_address" {
  default     = true
  description = "Variable to enable public ip address for the bastion/ec2"
}

variable "enable_ecr" {
  default     = true
  description = "This variable will decide whether the elastic container registries are created or not for the environment"
}

variable "ecr_repo_names" {
  type        = list(string)
  default     = ["fineract-non-prod","woooba-api-auth-non-prod","woooba-api-chat-non-prod","woooba-api-game-non-prod","woooba-api-geospatial-non-prod","woooba-api-payment-non-prod","woooba-api-payout-non-prod","woooba-api-pns-non-prod","woooba-api-pns-registration-non-prod","woooba-api-profile-non-prod","woooba-api-startup-non-prod","woooba-api-swagger-non-prod","woooba-api-swagger-internal-non-prod","woooba-api-wallet-non-prod","woooba-email-service-non-prod","woooba-event-queue-non-prod","woooba-notifier-non-prod","woooba-scheduler-non-prod"]
  description = "List of Docker local image names, used as repository names for AWS ECR "
}

variable "enable_lifecycle_policy" {
  type        = bool
  description = "Set to false to prevent the module from adding any lifecycle policies to any repositories"
  default     = true
}

variable "kubernetes_version" {
  default     ="1.28"
  description = "Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided"
}

variable "eks_cluster_name" {
  default     = "woooba-non-prod"
  description = "EKS prefix name given to create lable for the resources from label module "
}

variable "oidc_provider_enabled" {
  default     = true
  description = "Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html"
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
}

variable "write_kubeconfig" {
  default     = true
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
}

variable "map_additional_iam_users" {
  description = "Additional IAM users to add to `config-map-aws-auth` ConfigMap"
  
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  
  default = [
    {
      userarn  = "arn:aws:iam::533331915569:user/woooba-non-prod-access"
      username = "woooba-non-prod-access"
      groups   = ["system:masters"]
    }
  ]
}


variable "eks_nodegroup_instance_type" {
  default     = ["t3.large"]
  description = <<-EOT
    Single instance type to use for this node group, passed as a list. Defaults to ["t2.medium"].
    It is a list because Launch Templates take a list, and it is a single type because EKS only supports a single type per node group.
    EOT
}

variable "desired_size" {
  default     = 3
  description = "Initial desired number of worker nodes (external changes ignored)"
}

variable "min_size" {
  default     = 3
  description = "Minimum number of worker nodes"
}

variable "max_size" {
  default     = 4
  description = "Maximum number of worker nodes"
}

variable "disk_size" {
  default     = 50
  description = <<-EOT
    Disk size in GiB for worker nodes. Defaults to 20. Ignored it `launch_template_id` is supplied.
    Terraform will only perform drift detection if a configuration value is provided.
    EOT
}

variable "cluster_autoscaler_enabled" {
  default     = true
  description = "Set true to label the node group so that the [Kubernetes Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#auto-discovery-setup) will discover and autoscale it"
}

variable "existing_workers_role_policy_arns" {
  default     = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess", "arn:aws:iam::aws:policy/SecretsManagerReadWrite", "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  description = "List of existing policy ARNs that will be attached to the workers default role on creation"
}

variable "worker_role_autoscale_iam_enabled" {
  default     = true
  description = <<-EOT
    If true, the worker IAM role will be authorized to perform autoscaling operations. Not recommended.
    Use [EKS IAM role for cluster autoscaler service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) instead.
    EOT
}

variable "resources_to_tag" {
  default     = ["instance","volume"]
  description = "List of auto-launched resource types to tag. Valid types are \"instance\", \"volume\", \"elastic-gpu\", \"spot-instances-request\"."
}

variable "bastion_aws_key_pair_name" {
  default = "woooba-non-prod-bastion-key"
}

variable "ssh_public_key_path" {
  default     = "./secrets"
  description = "This is the local host path where the bastion public and private keys are stored once created"
}

variable "generate_ssh_key" {
  default     = true
  description = "This variable generate SSH key for the ec2 instance module"
}

variable "bastion_ami" {
  type        = string
  description = "The AMI to use for the instance/bastion. By default it is the AMI provided by Amazon with Ubuntu 20.04 LTS"
  default     = "ami-06aa3f7caf3a30282"
}

variable "ami_owner" {
  default     = "amazon"
  description = "This is a variable to choose the owner of the AMI that we have to choose for bastion/ec2"
}

variable "bastion_instance_type" {
  default     = "t2.micro"
  description = "The instance type of the ec2/bastion"
}

variable "ebs_volume_count" {
  type        = number
  description = "Count of EBS volumes that will be attached to the instance"
  default     = 1
}

variable "bastion_root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 30
}

variable "bastion_root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "bastion_delete_on_termination" {
  default     = true
  description = "Variable to Enable/Disable delete on termination feature for the ec2/bastion"
}

variable "bastion_monitoring" {
  default     = false
  description = "Enable/disable detailed Monitoring for the ec2/bastion instance"
}

variable "bastion_ebs_optimized" {
  type        = bool
  description = "Launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "bastion_allowed_ports" {
  default     = [80,443]
  description = "The allowed ports from the ec2/bastion on the security group"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = <<-EOT
    When `true`, permits a non-empty S3 bucket to be deleted by first deleting all objects in the bucket.
    THESE OBJECTS ARE NOT RECOVERABLE even if they were versioned and stored in Glacier.
    EOT
}

variable "versioning_enabled" {
  type        = bool
  default     = false
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
}

variable "bucket_name" {
  type        = string
  default     = "woooba-helm-values-nonproduction"
  description = "Bucket name. If provided, the bucket will be created with this name instead of generating the name from the context"
}
