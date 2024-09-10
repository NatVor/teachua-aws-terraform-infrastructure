## Installing Required Tools

To set up the necessary tools (kubectl, eksctl, AWS CLI, Helm, Terraform) on your machine, follow these steps:

1. Download the installation script to your machine:
   curl -O https://raw.githubusercontent.com/NatVor/terraform-aws/main/install_tools.sh
   
2. Make the script executable:
   chmod +x install_tools.sh
   
3. Run the script to install the tools:
   ./install_tools.sh
   The script will install all required tools and display their versions upon successful installation.
4. Verify the installation by checking the versions of the installed tools:
   kubectl version --client --short
   eksctl version
   aws --version
   helm version --short
   terraform -v
