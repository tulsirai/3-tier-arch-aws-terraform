# 🏗️ 3-Tier AWS Architecture with Terraform

This Terraform project provisions a **three-tier architecture** in AWS, including **VPC, ECS, and supporting infrastructure**.

---
## 🚀 **Prerequisites**
Ensure you have the following installed:
- **Terraform**: [Download here](https://developer.hashicorp.com/terraform/downloads)
- **AWS CLI**: [Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **AWS Credentials** configured (`~/.aws/credentials` or using `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`)

---

## 📌 **Setup & Usage**

1️⃣ Clone the Repository**
```sh
git clone https://github.com/your-repo/3-tier-arch-aws.git
cd 3-tier-arch-aws
2️⃣ Initialize Terraform
terraform init

3️⃣ Configure variables
traicloud-website-ecs/terraform.tfvars

4️⃣ Validate & Plan
terraform validate

terraform plan

5️⃣ Deploy Infrastructure
terraform apply -auto-approve

6️⃣ Destroy Infrastructure (if needed)
terraform destroy -auto-approve

🔑 State Management
terraform state list
terraform state show <resource>
