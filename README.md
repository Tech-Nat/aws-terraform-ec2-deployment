# AWS Terraform EC2 Deployment

This repository contains the Terraform configuration files for deploying an Amazon EC2 instance with specific requirements on AWS.

## Scenario

The goal is to create an EC2 instance with the following specifications:
- Instance Type: T2.Micro
- Storage: 12GB
- Region: Any (e.g., London)
- Access: SSH and RDP from a single IP address, HTTP access from anywhere

## Prerequisites

Before you begin, ensure you have the following:
- An AWS account
- Terraform installed on your machine
- An SSH key pair for EC2 instance access

## Deployment Steps

1. **Create a VPC** - Set up a Virtual Private Cloud to provide a logically isolated section of the AWS Cloud.
2. **Create an Internet Gateway (IGW)** - Attach an IGW to your VPC for internet connectivity.
3. **Create a Public Route Table** - Define routes for network traffic within your VPC.
4. **Create a Public Subnet** - Provision a subnet in the London region and associate it with the route table.
5. **Set Up a Security Group** - Define security rules to control inbound and outbound traffic for your EC2 instance.
6. **Create a Network Interface** - Allocate a network interface in the subnet with an assigned IP address.
7. **Assign an Elastic IP** - Associate an Elastic IP with the network interface to provide a static, public IP address.
8. **Launch an EC2 Instance** - Deploy the EC2 instance using the defined configurations and connect it to the network interface.

## Usage

After deploying the EC2 instance, you can access it via SSH or RDP using the provided IP address. Ensure your security group rules are configured to allow traffic from your IP address.

## Contributing

Contributions to this project are welcome. Please fork the repository, make your changes, and submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
