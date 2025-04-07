Here’s a clean and professional `README.md` for your Terraform project, based on the configuration you shared:

---

```markdown
# 🌐 AWS VPC Setup with Terraform

This Terraform configuration sets up basic AWS networking components for an application environment, including:

- A custom VPC
- A public subnet
- An internet gateway
- A default route table
- A security group allowing SSH and app traffic

---

## 📁 Project Structure

```
.
├── main.tf          # Terraform configuration
├── variables.tf     # Input variable definitions
├── terraform.tfvars # Variable values (excluded from repo for security)
└── README.md        # Project documentation
```

---

## ⚙️ Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with credentials
- An existing AWS account
- Your public IP address (for SSH access)

---

## 📦 Resources Created

| Resource                | Description                                |
|-------------------------|--------------------------------------------|
| `aws_vpc`               | Custom VPC                                 |
| `aws_subnet`            | Public subnet                              |
| `aws_internet_gateway`  | Internet gateway for outbound traffic      |
| `aws_default_route_table` | Configured with route to internet gateway |
| `aws_security_group`    | Allows SSH (port 22) and App (port 8080)   |

---

## 🧪 Input Variables

| Variable Name     | Description                              |
|-------------------|------------------------------------------|
| `vpc_cidr_block`  | CIDR block for the VPC                   |
| `subnet_cidr_block` | CIDR block for the subnet              |
| `avail_zone`      | AWS Availability Zone (e.g., `us-east-1a`) |
| `env_prefix`      | Prefix for naming resources              |
| `my_ip`           | Your IP with `/32` (e.g., `1.2.3.4/32`)  |

> Define these values in a `terraform.tfvars` file or pass them manually during apply.

---

## 🚀 Usage

1. **Clone the repo**
   ```bash
   git clone https://github.com/<your-username>/terraform-learn.git
   cd terraform-learn
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Validate the config**
   ```bash
   terraform validate
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

   > Optional: Disable state locking during apply (not recommended)
   ```bash
   terraform apply -lock=false
   ```

---

## 🔐 Security Group Rules

- **SSH (port 22)**: Only accessible from your IP (`my_ip`)
- **App (port 8080)**: Open to the public (`0.0.0.0/0`)
- **All outbound traffic**: Allowed

---

## 🧼 Cleanup

To tear down the infrastructure:

```bash
terraform destroy
```

---

## 📌 Notes

- This project currently uses **local state**. For production-grade setups, consider remote backends like **S3 + DynamoDB** for state locking and collaboration.
- The route table and association resources are included but commented out for future extension.
