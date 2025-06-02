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