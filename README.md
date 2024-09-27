teachua-terraform-aws-infrastructure
Installing Required Tools
To set up the necessary tools (kubectl, eksctl, AWS CLI, Helm, Terraform) on your machine, follow these steps:

Download the installation script to your machine: curl -O https://raw.githubusercontent.com/NatVor/terraform-aws/main/install_tools.sh

Make the script executable: chmod +x install_tools.sh

Run the script to install the tools: ./install_tools.sh

Verify the installation by checking the versions of the installed tools: kubectl version --client; eksctl version; aws --version; helm version --short; terraform -v

Connect to AWS: aws configure

or input

export AWS_ACCESS_KEY_ID="your-access-key"

export AWS_SECRET_ACCESS_KEY="your-secret-access-key"

export AWS_DEFAULT_REGION="your-region"

export AWS_DEFAULT_OUTPUT="json"

Helpful Commands: terraform output vpc_id terraform plan -out=plan.tfplan

sudo apt-get update && sudo apt-get install -y vault vault server -dev export VAULT_ADDR='http://127.0.0.1:8200

kubectl config get-contexts kubectl config use-context

After terraform apply:

aws eks --region us-east-1 update-kubeconfig --name teachua kubectl create namespace new-teachua

kubectl create secret docker-registry ghcr-secret
--docker-server=ghcr.io
--docker-username=your-github-username
--docker-password=your-github-token
--docker-email=your-email
--namespace=new-teachua

kubectl create secret generic teachua-db-secret
--from-literal=MYSQL_PASSWORD...

helm install teachua ./teachua-chart --namespace new-teachua helm upgrade teachua ./teachua-chart --namespace new-teachua

kubectl get all -n new-teachua

"teachua.ctegro5wnfvo.us-east-1.rds.amazonaws.com" "https://6B6C648AA86464F24574B06B1BF8922C.yl4.us-east-1.eks.amazonaws.com"

kubectl config use-context

kubectl create namespace new-teachua

apt-get update apt-get install mysql-client

mysql -u root -p teachua < /docker-entrypoint-initdb.d/data.sql
