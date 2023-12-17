# Infra-IAC for Non-prod

## Setting Up of AWS Environment based on best practices.
### Setting up the Below components in the Non-Production Environment with the help of Terraform. 

**Networking & Content Delivery**
1. Vpc
1. Subnets
1. Route tables
1. IGW
1. NAT
1. Elastic IP’s
1. Security Groups

**Compute**
1. EC2-bastion

**Containers**
1. ECR
1. EKS

**Storage**
1. S3 Buckets

**Security, Identity, and Compliance**
1. IAM Roles

The above-listed components will be created in the AWS cloud for the Non-production Woooba application.

### Commands to apply the Terraform code

1. **Step 1**
   - ***terraform init:*** The Terraform init command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

1. **Step 2**
   - ***terraform plan:*** The Terraform plan command lets you preview the actions Terraform would take to modify your infrastructure or save a speculative plan which you can apply later. The function of a terraform plan is speculative: you can only apply it if you save its contents and pass them to a terraform apply command.

1. **Step 3**
   - ***terraform apply:*** The terraform apply command performs a plan just like the terraform plan does, but then carries out the planned changes to each resource using the relevant infrastructure provider's API. It asks for confirmation from the user before making any changes, unless it was explicitly told to skip approval.
    
> [!NOTE]
> Before applying the resources (except backend-for-non-prod). In _environments/non-prod/main.tf_ you need to comment module **eks_cluster** and module **eks_node_group** fully. Also, fully comment **data null_data_source** from _environments/non-prod/data.tf_. Then do terraform init, plan, and apply with the remaining uncommented resources. We are doing this because our EKS cluster will be in a Private endpoint so our local system which contains our terraform code will not be able to connect to our cluster to setup nodegroups through terraform. So we need to set up a VPN server.

> [!IMPORTANT]
> 1. When applying the terraform template for the first time you need first to create an S3 buckect and a DynamoDB table to keep and lock our terraform state file. For that follow the below steps.
>   - **step: 1** From the root folder go to _environment/backend-for-non-prod/main.tf_. From there open a new terminal then do terraform init, plan, and apply.
>   - **Step: 2** To create other resources (Networking, Bastion, ECR, S3) follow the step 3
>   - **step: 3** Go to _environment/non-prod/main.tf_. To apply the resources to our AWS account. Open a terminal there and do terraform init, plan, and apply.

After resources are created go to the AWS console and connect to the pritunl server using the public IP of _woooba-non-prod-bastion-host_, Also login to the _woooba-non-prod-bastion-host_ ec2-instance, and configure the pritunl server. Follow the below steps.

1. **Step: 1**
   - At this point, Pritunl VPN is installed and running. Access it from the browser using your server IP to configure it. http://<your_server_ip>. You should get a page as below:
   ![Screenshot 2023-11-22 173759](https://github.com/WOOOBA/Infra-IAC/assets/149389881/938df73b-5904-4e61-b8cf-310c87864d21)
1. **Step: 2**
   - Generate setup-key by running the command in your woooba-non-prod-bastion-host. 
     - _sudo pritunl setup-key_
1. **Step: 3**
   - Once you enter the setup key and MongoDB URL, it will prompt you for a username and password.
   - The default username and password are obtained with the below command:
     - _sudo pritunl default-password_
1. **Step: 4**
   - When you login with the provided credentials, you get a page as below:
   ![Screenshot 2023-11-22 174444](https://github.com/WOOOBA/Infra-IAC/assets/149389881/ba188b38-00bf-4a86-88e7-9f98c10d9d89)
   - Set your new password and save and you should be taken to a page to configure organizations, users, and servers.
1. **Step: 5**
   - To add users, click on ‘Users’. This takes you to a window to first add organization.
   ![Screenshot 2023-11-22 175030](https://github.com/WOOOBA/Infra-IAC/assets/149389881/be42b1c1-f863-41c6-ac5b-a3c820a6ed03)
   ![Screenshot 2023-11-22 175147](https://github.com/WOOOBA/Infra-IAC/assets/149389881/f655a741-a27f-48ad-a536-b49c2d1039d6)
1. **Step: 6**
   - Click on ‘Add organization’ then provide it a name then click ‘Add’.
   ![Screenshot 2023-11-22 175256](https://github.com/WOOOBA/Infra-IAC/assets/149389881/7425a55b-585b-4e0e-b35d-5409a88ed76b)
   - Your organization should now be added as below
   ![Screenshot 2023-11-22 175430](https://github.com/WOOOBA/Infra-IAC/assets/149389881/5e50e2a9-c0aa-4018-a29b-7f5b2b7c60e9)
1. **Step: 7**
   - Click on ‘Add user’ to create a user. Provide the required details and click ‘Add’.
   ![Screenshot 2023-11-22 175539](https://github.com/WOOOBA/Infra-IAC/assets/149389881/f8bea5d8-633f-4773-88c5-4fb1b6bb14e9)
   - If you want to add many users at once, click on ‘Bulk Add user’.
1. **Step: 8**
   - Let’s now create a VPN server. Click on ‘servers’ then ‘Add server’
   ![Screenshot 2023-11-22 175724](https://github.com/WOOOBA/Infra-IAC/assets/149389881/76f87a64-1255-4535-93ff-c84f814b5067)
1. **Step: 9**
   - Provide server particulars and click ‘Add’. You should see that the server has successfully been added as below:
   ![Screenshot 2023-11-22 175853](https://github.com/WOOOBA/Infra-IAC/assets/149389881/8f27b0a9-c8f2-42bf-bc0b-f2fa94c01aed)

> [!NOTE]
> Remember to attach the server to an organization by clicking on **‘Attach organization’** and choosing your organization. Also, you need to **‘add Route’** which is your woooba-non-prod-vpc CIDR, then click on **‘Start Server’**.

1. **Step: 10**
   - Then install the pritunl client on your local computer and import the user profile (which can be downloaded from the pritunl server users) to the client that is downloaded from the pritunl server. then connect to the VPN. After that, you can fully uncomment the module **eks_cluster** and module **eks_node_group** from the terraform code _environments/non-prod/main.tf_ and re-apply the terraform code again to create eks cluster and node group.
1. **Step: 11 (optional)**
   - If you need to destroy the infrastructure. First, you need to destroy the module eks_cluster and module eks_node_group from the terraform code _environments/non-prod/main.tf_ then you can destroy the rest of the resources. Using the terraform destroy command.

> [!NOTE]
> You need to connect your local machine with pritunl server to make any changes or destroy the infrastructure with Terraform.