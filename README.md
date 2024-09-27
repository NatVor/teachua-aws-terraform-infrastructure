TeachUA-terraform-aws-infrastructure

Installing Required Tools

To set up the necessary tools (kubectl, eksctl, AWS CLI, Helm, Terraform) on your machine, follow these steps:

Make the script executable: chmod +x install_tools.sh

Run the script to install the tools: ./install_tools.sh

Verify the installation by checking the versions of the installed tools: kubectl version --client; eksctl version; aws --version; helm version --short; terraform -v

Connect to AWS: aws configure

or input

export AWS_ACCESS_KEY_ID="your-access-key"

export AWS_SECRET_ACCESS_KEY="your-secret-access-key"

export AWS_DEFAULT_REGION="your-region"

export AWS_DEFAULT_OUTPUT="json"

After terraform apply:

aws eks --region us-east-1 update-kubeconfig --name teachua 
kubectl create namespace new-teachua

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

Helpful Commands: 

kubectl config get-contexts 
kubectl config use-context
apt-get update apt-get install mysql-client
