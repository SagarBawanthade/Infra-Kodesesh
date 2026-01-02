# 🏗️ Kodesesh Infrastructure (Terraform)

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-FF6C37?style=for-the-badge&logo=gitbook&logoColor=white)

**Production-grade Infrastructure as Code for VPS automation**

[Features](#-features) • [Architecture](#-architecture) • [Usage](#-getting-started) • [Security](#-security)

</div>

---

## 📋 Overview

This repository contains the **Infrastructure as Code (IaC)** configuration for the **Kodesesh** project, implementing automated VPS preparation using Terraform. The infrastructure follows **real-world DevOps practices** by clearly separating infrastructure management from application deployment.

### 🎯 Purpose

Terraform is used to **prepare and standardize a long-running VPS**, ensuring it's always ready for CI/CD-based application deployments. This setup maintains infrastructure readiness while keeping the deployment pipeline separate and clean.

---

## ✨ Features

### What Terraform Manages

✅ **Docker Engine Installation** - Ensures Docker is installed and up-to-date  
✅ **Service Management** - Docker service is enabled and running  
✅ **Network Configuration** - Creates and maintains `kodesesh-network`  
✅ **Environment Preparation** - Ensures required configuration files exist  
✅ **Idempotent Operations** - Safe to run multiple times without side effects  
✅ **Infrastructure State** - Declarative configuration for consistent results

### What Terraform Does NOT Manage

❌ Application container deployment  
❌ Container lifecycle management  
❌ Secret values or sensitive data  
❌ CI/CD pipeline execution  
❌ VPS creation or destruction  

> **Design Philosophy**: Infrastructure preparation and application deployment are intentionally separated to follow DevOps best practices.

---

## 🏛️ Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Kodesesh Infrastructure                   │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────┐         ┌──────────────────────────┐
│   Terraform (IaC Layer)  │         │   CI/CD (App Layer)      │
├──────────────────────────┤         ├──────────────────────────┤
│                          │         │                          │
│  • Docker Installation   │         │  • Build Docker Images   │
│  • Service Enablement    │────────▶│  • Push to Registry      │
│  • Network Creation      │         │  • Deploy Containers     │
│  • Environment Setup     │         │  • Manage Lifecycle      │
│  • VPS Readiness         │         │  • Rolling Updates       │
│                          │         │                          │
└──────────────────────────┘         └──────────────────────────┘
         │                                      │
         │                                      │
         ▼                                      ▼
┌─────────────────────────────────────────────────────────────┐
│                      Production VPS                          │
│  • Ubuntu/Debian Server                                      │
│  • Docker Network: kodesesh-network                          │
│  • Environment File: /home/sagar/environmnet-file.env               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📂 Repository Structure
```
terraform/
├── 📄 main.tf                 # Main infrastructure configuration
├── 📄 provider.tf             # Provider and connection settings
├── 📄 variables.tf            # Variable definitions
├── 🔒 .terraform.lock.hcl     # Dependency lock file
├── 🚫 .gitignore              # Git ignore rules
├── 📁 scripts/
│   └── setup_vps.sh           # VPS initialization script
└── 📖 README.md               # This file
```

---

## 🚀 Getting Started

### Prerequisites

- **Terraform** v1.0 or higher ([Install Guide](https://developer.hashicorp.com/terraform/downloads))
- **SSH Access** to target VPS
- **Root or sudo privileges** on the VPS
- **SSH Key** configured for passwordless authentication

### Installation

1. **Clone the repository**
```bash
   git clone https://github.com/yourusername/kodesesh-infrastructure.git
   cd kodesesh-infrastructure/terraform
```

2. **Initialize Terraform**
```bash
   terraform init
```
   This downloads required providers and prepares the working directory.

3. **Review the configuration**
```bash
   terraform plan
```
   Examine what changes Terraform will make to your infrastructure.

4. **Apply the configuration**
```bash
   terraform apply
```
   Type `yes` when prompted to confirm the changes.

### Configuration

Before running Terraform, ensure you have:

1. **SSH Configuration** - Set up SSH access in `provider.tf`:
```hcl
   connection {
     type        = "ssh"
     host        = var.vps_ip
     user        = var.ssh_user
     private_key = file(var.ssh_private_key_path)
   }
```

2. **Variables** - Define in `terraform.tfvars` (not committed):
```hcl
   vps_ip                = "your.vps.ip.address"
   ssh_user              = "your-user"
   ssh_private_key_path  = "~/.ssh/id_rsa"
```

3. **Environment File** - Ensure `/home/sagar/environmnet-file.env` exists on the VPS with required application variables (contents managed externally).

---

## 🔧 Usage Examples

### Check Infrastructure State
```bash
terraform show
```

### Validate Configuration
```bash
terraform validate
```

### Format Configuration Files
```bash
terraform fmt
```

### Destroy Infrastructure (if needed)
```bash
terraform destroy
```

### Re-apply Infrastructure
```bash
terraform apply -auto-approve
```
> Infrastructure is idempotent - safe to run multiple times

---

## 🔐 Security

### What's Protected

✅ **SSH Keys** - Never committed to repository  
✅ **State Files** - Excluded via `.gitignore`  
✅ **Environment Variables** - Values managed externally  
✅ **Secrets** - Handled via CI/CD or secure provisioning  
✅ **Terraform Variables** - Sensitive values in `terraform.tfvars` (gitignored)

### Security Best Practices

1. **Never commit sensitive data**
   - State files contain infrastructure details
   - Use remote state backends for team environments
   - Keep `terraform.tfvars` out of version control

2. **Environment file management**
   - Terraform ensures `/home/sagar/kodesesh.env` exists
   - File contents are provisioned separately
   - Secrets stored in CI/CD variables or vault solutions

3. **SSH key security**
   - Use SSH keys with passphrases
   - Restrict key permissions (`chmod 600`)
   - Use different keys for different environments

### `.gitignore` Configuration
```gitignore
# Terraform files
*.tfstate
*.tfstate.*
.terraform/
terraform.tfvars
*.tfvars

# Sensitive files
*.pem
*.key
```

---

## 🧠 Design Decisions

### Why Terraform for Infrastructure?

- **Declarative Configuration** - Define desired state, not steps
- **Idempotency** - Safe to run multiple times
- **Version Control** - Infrastructure changes are tracked
- **Reproducibility** - Consistent across environments

### Why NOT Kubernetes?

For a single-node VPS deployment:
- Kubernetes adds unnecessary complexity
- Docker Compose provides sufficient orchestration
- Easier to maintain and debug
- Lower resource overhead
- Faster deployment cycles

### Separation of Concerns

| Concern | Managed By | Why |
|---------|------------|-----|
| Infrastructure | Terraform | Reproducible, versioned setup |
| Secrets | CI/CD Variables | Prevents leakage via state files |
| Deployment | GitHub Actions | Application-specific logic |
| Runtime | Docker | Container orchestration |

---

## 🎓 Skills Demonstrated

This project showcases:

- ✅ **Infrastructure as Code (IaC)** with Terraform
- ✅ **VPS Automation** and standardization
- ✅ **Docker** service and network management
- ✅ **Idempotent Infrastructure** design
- ✅ **Security Best Practices** for secrets management
- ✅ **DevOps Principles** - separation of concerns
- ✅ **Production-Ready** infrastructure patterns
- ✅ **Real-World Decision Making** - avoiding over-engineering

---


</div>
