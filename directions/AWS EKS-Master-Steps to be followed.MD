================================================================
Setup Kubernetes (K8s) Cluster on Using AWS EKS
================================================================

================================================================
What is AWS EKSeksctl?
================================================================
AWS EKS:    
- Elastic Kubernetes Service (Amazon EKS)
- Fully Managed service
- Using EKS, you can run Kubernetes on AWS
- Using EKS, you dont need to install, operate, and maintain your own Kubernetes control plane or nodes

eksctl:
- A command line tool for working with EKS clusters that automates many individual tasks

kubectl:
- A command line tool for working with Kubernetes clusters.

================================================================
Steps to be followed
================================================================
1. Install Kubectl (https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
    1.1.  Open a PowerShell terminal

    1.2.  Download the Amazon EKS vended kubectl binary for your cluster's Kubernetes version from Amazon S3:
         $ curl -o kubectl.exe https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/windows/amd64/kubectl.exe
         $ Get-FileHash kubectl.exe

    1.3.  Copy the kubectl.exe binary to your new directory.(ex: C:\kubectl)

    1.4.  Edit your user or system PATH environment variable to add the new directory to your PATH.
         ex: PATH=$PATH:C:\kubectl\
         $ kubectl version --short --client

2. Install eksctl   (https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
    1.1.  Open link https://github.com/weaveworks/eksctl/releases/download/0.43.0/eksctl_Windows_amd64.zip

    1.2.  Download the Amazon EKS tool eksctl and extract to a new folder C:\eksctl

    1.3.  Copy the kubectl.exe binary to your new directory.(ex: C:\eksctl)

    1.4.  Edit your user or system PATH environment variable to add the new directory to your PATH.
          ex: PATH=$PATH:C:\eksctl\
          $ eksctl version

3. Create EKS kubernetes cluster using following command
      $ eksctl create cluster --name sigmaEKS-Cluster --region us-east-2 --with-oidc --ssh-access --ssh-public-key KeyPair-Ohio --managed

4. To list all namespaces
            $ kubectl get namespaces

5. To permanently set the namespace for all subsequent kubectl commands in that context
            $ kubectl config set-context --current --namespace=kube-system

6.   Create a Deployments for application
            $ vi ion-deployment.yaml
            $ kubectl apply -f ion-eks-deployment.yml

7.   Create service for the deployment
            $ vi ion-service.yaml
            $ kubectl apply -f ion-eks-service.yml

8.   To list deployments
            $ kubectl get deployments

9.   To list pods
            $ kubectl get pods

10.   To list services
            $ kubectl get services -o wide

11.   Open the browser and copy the DNS of the Load balancers

12.   To delete cluster
            $ eksctl delete cluster --name sigmaEKS-Cluster
