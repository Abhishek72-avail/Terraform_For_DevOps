# Complete Terraform Guide - From Basics to Production

## Table of Contents
1. [What is Terraform?](#what-is-terraform)
2. [Why Use Terraform?](#why-use-terraform)
3. [Real-World Use Cases](#real-world-use-cases)
4. [Installation Guide](#installation-guide)
5. [Basic Setup](#basic-setup)
6. [Core Concepts](#core-concepts)
7. [Your First Terraform Project](#your-first-terraform-project)
8. [Advanced Features](#advanced-features)
9. [Best Practices](#best-practices)
10. [Common Commands](#common-commands)

## What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool developed by HashiCorp. It allows you to define and provision infrastructure using a declarative configuration language called **HashiCorp Configuration Language (HCL)**.

### Key Features:
- **Multi-cloud support**: AWS, Azure, Google Cloud, and 100+ providers
- **Declarative syntax**: You describe what you want, not how to build it
- **State management**: Keeps track of your infrastructure
- **Plan and apply**: Preview changes before implementing
- **Resource graph**: Understands dependencies between resources

## Why Use Terraform?

### Traditional Infrastructure Problems:
- Manual server setup (time-consuming and error-prone)
- Configuration drift (servers become inconsistent over time)
- Difficult to replicate environments
- No version control for infrastructure
- Hard to scale and manage

### Terraform Solutions:
- **Consistency**: Same infrastructure every time
- **Version Control**: Track changes like code
- **Automation**: Reduce manual errors
- **Scalability**: Easily manage hundreds of resources
- **Cost Management**: Destroy unused resources easily

## Real-World Use Cases

### 1. Multi-Environment Management
```
Development → Staging → Production
```
Create identical environments with different configurations.

### 2. Disaster Recovery
Quickly recreate entire infrastructure in different regions.

### 3. Auto-Scaling Applications
Set up load balancers, auto-scaling groups, and databases automatically.

### 4. Microservices Infrastructure
Deploy containerized applications with all supporting services.

### 5. Compliance and Security
Ensure consistent security policies across all environments.

### 6. Cost Optimization
Schedule resources to start/stop based on usage patterns.

## Installation Guide

### Prerequisites
- Operating System: Windows, macOS, or Linux
- Administrative privileges
- Internet connection

### Method 1: Direct Download (Recommended)

#### For Windows:
1. Visit [Terraform Downloads](https://www.terraform.io/downloads)
2. Download the Windows 64-bit version
3. Extract the ZIP file
4. Move `terraform.exe` to a directory in your PATH
5. Open Command Prompt and verify: `terraform --version`

#### For macOS:
```bash
# Using Homebrew (recommended)
brew install terraform

# Or download directly
curl -O https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_darwin_amd64.zip
unzip terraform_1.6.6_darwin_amd64.zip
sudo mv terraform /usr/local/bin/
```

#### For Linux (Ubuntu/Debian):
```bash
# Method 1: Package manager
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Method 2: Direct download
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Method 2: Using Package Managers

#### Windows (Chocolatey):
```powershell
choco install terraform
```

#### macOS (Homebrew):
```bash
brew install terraform
```

#### Linux (Snap):
```bash
sudo snap install terraform
```

### Verification
```bash
terraform --version
# Should output: Terraform v1.6.6 (or your installed version)
```

## Basic Setup

### 1. Create Your First Project Directory
```bash
mkdir my-terraform-project
cd my-terraform-project
```

### 2. Set Up Your Development Environment

#### Recommended Text Editors:
- **VS Code** with HashiCorp Terraform extension
- **IntelliJ IDEA** with Terraform plugin
- **Vim** with terraform.vim plugin

#### VS Code Setup:
1. Install VS Code
2. Install the "HashiCorp Terraform" extension
3. This provides syntax highlighting, auto-completion, and validation

### 3. Configure Cloud Provider Credentials

#### AWS Example:
```bash
# Install AWS CLI first
# Then configure credentials
aws configure
```

#### Environment Variables Method:
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-west-2"
```

## Core Concepts

### 1. Providers
Providers are plugins that interact with APIs of cloud platforms.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
```

### 2. Resources
Resources are the most important element in Terraform. They describe infrastructure objects.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1d0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "HelloWorld"
  }
}
```

### 3. Data Sources
Data sources allow you to fetch information from existing infrastructure.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

### 4. Variables
Variables make your configurations flexible and reusable.

```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
}
```

### 5. Outputs
Outputs display useful information after applying your configuration.

```hcl
output "instance_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.web.public_ip
}
```

## Your First Terraform Project

Let's create a simple AWS EC2 instance:

### Step 1: Create main.tf
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  tags = {
    Name        = "MyFirstTerraformInstance"
    Environment = "Learning"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}
```

### Step 2: Initialize Terraform
```bash
terraform init
```
This downloads the required providers and sets up the working directory.

### Step 3: Plan Your Changes
```bash
terraform plan
```
This shows you what Terraform will create, modify, or destroy.

### Step 4: Apply Your Configuration
```bash
terraform apply
```
Type `yes` when prompted to create the infrastructure.

### Step 5: Verify Your Instance
Check your AWS console to see your new EC2 instance!

### Step 6: Clean Up
```bash
terraform destroy
```
This removes all resources created by Terraform.

## Advanced Features

### 1. State Management
Terraform keeps track of your infrastructure in a state file.

#### Remote State (Recommended for Teams):
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "prod/terraform.tfstate"
    region = "us-west-2"
  }
}
```

### 2. Modules
Modules help you organize and reuse code.

#### Creating a Module:
```
modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

#### Using a Module:
```hcl
module "web_server" {
  source = "./modules/ec2"
  
  instance_type = "t2.small"
  environment   = "production"
}
```

### 3. Workspaces
Workspaces allow you to manage multiple environments.

```bash
terraform workspace new development
terraform workspace new production
terraform workspace select development
```

### 4. Provisioners
Execute scripts on resources after creation.

```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }
}
```

## Best Practices

### 1. File Organization
```
project/
├── main.tf          # Main configuration
├── variables.tf     # Variable definitions
├── outputs.tf       # Output definitions
├── versions.tf      # Provider versions
└── terraform.tfvars # Variable values
```

### 2. Naming Conventions
- Use descriptive resource names
- Follow consistent naming patterns
- Use tags for resource organization

### 3. Version Control
- Always use version control (Git)
- Never commit `terraform.tfstate` files
- Use `.gitignore` for sensitive files

### 4. Security
- Use remote state storage
- Enable state locking
- Never hardcode secrets
- Use variables for sensitive data

### 5. Testing
- Use `terraform plan` before applying
- Test in development environments first
- Use `terraform validate` to check syntax

## Common Commands

### Basic Commands
```bash
# Initialize working directory
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Show current state
terraform show

# List resources
terraform state list
```

### Advanced Commands
```bash
# Import existing resources
terraform import aws_instance.example i-1234567890abcdef0

# Refresh state
terraform refresh

# Target specific resources
terraform apply -target=aws_instance.web

# Use variable files
terraform apply -var-file="prod.tfvars"

# Generate dependency graph
terraform graph | dot -Tpng > graph.png
```

## Terraform Import Command - Complete Guide

### What is Terraform Import?

The `terraform import` command allows you to bring existing infrastructure resources under Terraform management. This is useful when you have resources created manually or by other tools that you want to manage with Terraform.

### Basic Import Syntax
```bash
terraform import [options] RESOURCE_TYPE.NAME RESOURCE_ID
```

### Common Import Examples

#### 1. AWS EC2 Instance
```bash
# First, define the resource in your .tf file
resource "aws_instance" "imported_server" {
  # Configuration will be filled after import
}

# Import the existing instance
terraform import aws_instance.imported_server i-1234567890abcdef0
```

#### 2. AWS S3 Bucket
```bash
# Define resource in .tf file
resource "aws_s3_bucket" "imported_bucket" {
  # Configuration
}

# Import existing bucket
terraform import aws_s3_bucket.imported_bucket my-existing-bucket-name
```

#### 3. AWS VPC
```bash
# Define resource
resource "aws_vpc" "main" {
  # Configuration
}

# Import VPC
terraform import aws_vpc.main vpc-12345678
```

#### 4. AWS Security Group
```bash
# Define resource
resource "aws_security_group" "web" {
  # Configuration
}

# Import security group
terraform import aws_security_group.web sg-12345678
```

#### 5. AWS RDS Instance
```bash
# Define resource
resource "aws_db_instance" "main" {
  # Configuration
}

# Import RDS instance
terraform import aws_db_instance.main mydb-instance
```

#### 6. AWS Load Balancer
```bash
# Define resource
resource "aws_lb" "main" {
  # Configuration
}

# Import ALB/NLB
terraform import aws_lb.main arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188
```

### Azure Resources Import Examples

#### 1. Azure Resource Group
```bash
# Define resource
resource "azurerm_resource_group" "main" {
  # Configuration
}

# Import resource group
terraform import azurerm_resource_group.main /subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resources
```

#### 2. Azure Virtual Machine
```bash
# Define resource
resource "azurerm_linux_virtual_machine" "main" {
  # Configuration
}

# Import VM
terraform import azurerm_linux_virtual_machine.main /subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/mygroup1/providers/Microsoft.Compute/virtualMachines/machine1
```

### Google Cloud Platform Import Examples

#### 1. GCP Compute Instance
```bash
# Define resource
resource "google_compute_instance" "main" {
  # Configuration
}

# Import instance
terraform import google_compute_instance.main projects/my-project/zones/us-central1-a/instances/my-instance
```

#### 2. GCP Storage Bucket
```bash
# Define resource
resource "google_storage_bucket" "main" {
  # Configuration
}

# Import bucket
terraform import google_storage_bucket.main my-bucket-name
```

### Step-by-Step Import Process

#### Step 1: Find Resource ID
First, identify the existing resource ID from your cloud provider:

```bash
# AWS - List EC2 instances
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,Name:Tags[?Key==`Name`].Value|[0]}'

# AWS - List S3 buckets
aws s3 ls

# Azure - List VMs
az vm list --output table

# GCP - List instances
gcloud compute instances list
```

#### Step 2: Create Resource Block
Create the resource definition in your `.tf` file:

```hcl
resource "aws_instance" "imported_server" {
  # Leave empty initially - we'll fill this after import
}
```

#### Step 3: Import the Resource
```bash
terraform import aws_instance.imported_server i-1234567890abcdef0
```

#### Step 4: Generate Configuration
After import, you need to match your configuration with the actual resource:

```bash
# Show the current state to see actual values
terraform show

# Or use terraform show with specific resource
terraform state show aws_instance.imported_server
```

#### Step 5: Update Configuration
Update your `.tf` file to match the imported resource:

```hcl
resource "aws_instance" "imported_server" {
  ami           = "ami-0c55b159cbfafe1d0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "ImportedServer"
  }
  
  # Add other required attributes based on terraform show output
}
```

#### Step 6: Plan and Verify
```bash
# Check if configuration matches imported resource
terraform plan

# Should show "No changes" if configuration is correct
```

### Import Multiple Resources Script

Create a bash script to import multiple resources:

```bash
#!/bin/bash
# import_resources.sh

# Import multiple EC2 instances
terraform import aws_instance.web1 i-1234567890abcdef0
terraform import aws_instance.web2 i-0987654321fedcba0
terraform import aws_instance.db1 i-1111222233334444

# Import security groups
terraform import aws_security_group.web sg-12345678
terraform import aws_security_group.db sg-87654321

# Import VPC components
terraform import aws_vpc.main vpc-12345678
terraform import aws_subnet.public subnet-12345678
terraform import aws_internet_gateway.main igw-12345678

echo "Import completed!"
```

Make it executable and run:
```bash
chmod +x import_resources.sh
./import_resources.sh
```

### Import with Remote State

When using remote state backend:

```bash
# Ensure you're using the correct workspace
terraform workspace select production

# Import to remote state
terraform import aws_instance.web i-1234567890abcdef0
```

### Advanced Import Techniques

#### 1. Import with Variables
```bash
# Using variables in import
terraform import aws_instance.web[0] i-1234567890abcdef0
terraform import aws_instance.web[1] i-0987654321fedcba0
```

#### 2. Import with Modules
```bash
# Import resources inside modules
terraform import module.vpc.aws_vpc.main vpc-12345678
terraform import module.web.aws_instance.server i-1234567890abcdef0
```

#### 3. Import with For_Each
```bash
# For resources created with for_each
terraform import 'aws_instance.web["server1"]' i-1234567890abcdef0
terraform import 'aws_instance.web["server2"]' i-0987654321fedcba0
```

### Common Import Scenarios

#### Scenario 1: Migrating from Manual Infrastructure
```bash
# 1. Inventory existing resources
aws ec2 describe-instances > existing_instances.json

# 2. Create Terraform configuration
# 3. Import each resource
terraform import aws_instance.web1 i-1234567890abcdef0
terraform import aws_instance.web2 i-0987654321fedcba0

# 4. Adjust configuration to match imported state
# 5. Run terraform plan to verify
```

#### Scenario 2: Taking Over from Another Tool
```bash
# Import resources created by CloudFormation, ARM templates, etc.
# Follow the same process: identify → define → import → configure
```

#### Scenario 3: Disaster Recovery
```bash
# Import resources recreated manually during outage
# Bring them back under Terraform control
```

### Import Limitations and Considerations

#### What CAN be Imported:
- Most cloud resources (EC2, RDS, VPC, etc.)
- Existing infrastructure components
- Resources created by other tools

#### What CANNOT be Imported:
- Resources that don't exist in the provider
- Terraform-specific constructs (locals, data sources)
- Some provider-specific resources

#### Important Notes:
1. **State Only**: Import only adds to state, doesn't create configuration
2. **Manual Configuration**: You must write the configuration manually
3. **No Validation**: Terraform doesn't validate imported resources initially
4. **Dependencies**: You may need to import related resources too

### Troubleshooting Import Issues

#### Common Errors and Solutions:

1. **Resource Not Found**
```bash
Error: Cannot import non-existent remote object
```
**Solution**: Verify resource ID and region

2. **Resource Already Managed**
```bash
Error: Resource already managed by Terraform
```
**Solution**: Check if resource is already in state

3. **Invalid Resource ID Format**
```bash
Error: Invalid resource ID format
```
**Solution**: Check provider documentation for correct ID format

4. **Permission Denied**
```bash
Error: UnauthorizedOperation
```
**Solution**: Verify cloud provider credentials and permissions

### Import Best Practices

1. **Plan First**: Always run `terraform plan` after import
2. **Small Batches**: Import resources in small groups
3. **Document Process**: Keep track of what you've imported
4. **Backup State**: Always backup state before importing
5. **Test Environment**: Practice import process in test environment first
6. **Version Control**: Commit configuration changes after successful import

### Automated Import Tools

#### 1. Terraformer
Generate Terraform configuration from existing infrastructure:
```bash
# Install terraformer
brew install terraformer

# Generate configuration for AWS
terraformer import aws --resources=ec2_instance,vpc --regions=us-west-2
```

#### 2. Former2
Web-based tool to generate Terraform from AWS resources:
- Visit [former2.com](https://former2.com)
- Select AWS resources
- Generate Terraform configuration

#### 3. Cloud-specific Tools
- **AWS**: `aws2tf`
- **Azure**: `azure2tf`
- **GCP**: `gcp2tf`

### Workspace Commands
```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new staging

# Switch workspace
terraform workspace select production

# Delete workspace
terraform workspace delete staging
```

## Troubleshooting

### Common Issues:

1. **Provider not found**: Run `terraform init`
2. **State locked**: Use `terraform force-unlock LOCK_ID`
3. **Resource conflicts**: Check for existing resources
4. **Permission denied**: Verify cloud provider credentials

### Debugging:
```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform apply

# Save logs to file
export TF_LOG_PATH=./terraform.log
```

## Next Steps

1. **Learn More Providers**: Explore Azure, Google Cloud, Kubernetes
2. **Study Modules**: Create reusable infrastructure components
3. **Implement CI/CD**: Automate Terraform with GitHub Actions or Jenkins
4. **Advanced Topics**: Learn about Terraform Cloud, Sentinel policies
5. **Community**: Join Terraform community forums and GitHub discussions

## Resources

- [Official Terraform Documentation](https://www.terraform.io/docs)
- [Terraform Registry](https://registry.terraform.io/) - Find providers and modules
- [Learn Terraform](https://learn.hashicorp.com/terraform) - Official tutorials
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

**Happy Infrastructure Coding! 🚀**

Remember: Start small, test often, and gradually build more complex infrastructure as you learn.