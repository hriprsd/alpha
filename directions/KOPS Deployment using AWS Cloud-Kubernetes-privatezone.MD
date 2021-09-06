================================================================
Setup Kubernetes (K8s) Cluster on AWS
================================================================

================================================================
What is kops?
================================================================
kops - Kubernetes Operations

We like to think of it as kubectl for clusters
Easiest way to get a production grade Kubernetes cluster up and running
kops helps you create, destroy, upgrade and maintain production-grade, highly available,Kubernetes clusters from the command line
AWS (Amazon Web Services) is currently officially supported

================================================================
What we need to get started ?
================================================================
 - An S3 bucket required to store kops sessions state
 - To run kops, an EC2 Instance is required
 - kops does create/manage EC2 Instances(Kube Master and Nodes),IAM Roles (for Kube Master and Nodes), Route53
 - IAM Role with FUllAccess to EC2 || S3 || IAM || Route53 || VPC
 - Private/Public DNS Zone created from AWS Route53
 - 'kubectl', CLI tool for Kubernetes
 - DNS hostname to be enabled for VPC

================================================================
Steps to be followed
================================================================

1.    To store all the sessions for Kubernetes State,we need to Create an S3 bucket
      Create an S3 bucket, ex: <<kub-ion-bucket-us-east-2>>
            $ export KOPS_STATE_STORE=s3://kub-ion-bucket-us-east-2

2.    Create an IAM role with IAM,EC2,S3 and Route53 Full access(k8-role)

3.    Create an EC2 instance with {k8-role},which has ability to create/delete/manage
      EC2 Instances|| S3 Buckets || Domain Resolution (Route53) || Roles for EC2 machices

4.    For Kubernetes to work with CLI, will need to install kubectl on ubuntu instance
      # https://kubernetes.io/docs/setup/production-environment/tools/kops/

5.    To Install kops on Ubuntu instance
      # https://kubernetes.io/docs/setup/production-environment/tools/kops/

6.    Move to AWS account,Create a Route53 Private hosted zone,
      Private Domain Name: thessadcloud.net

7.    Expose environment variable:
            $ export KOPS_STATE_STORE=s3://kub-ion-bucket-us-east-2

8.    To get listed all clusters
            $ kops get clusters

9.   Master node will need to interact with Kube Node, hence we need a secret key to be created on Master node
     Create sshkeys before creating cluster
          $ ssh-keygen

10.   Create kubernetes cluster,for Private Hosted zone
            $ kops create cluster --cloud=aws --zones=us-east-2a,us-east-2b --name=kub.ion-app.thessadcloud.net
            --dns-zone=thessadcloud.net --dns private --yes

            $ kops create cluster --cloud=aws --zones=us-west-2a,us-west-2b --name=kub.ion-app.thessadcloud.net --dns-zone=thessadcloud.net --dns private --yes

11.    Set the KOPS_CLUSTER_NAME variable, if you haven't set it already
            $ export KOPS_CLUSTER_NAME=kub.ion-app.thessadcloud.net

12.    To Validate your cluster
            $ kops validate cluster   

13.       To list all namespaces
            $ kubectl get namespaces

14.   To permanently set the namespace for all subsequent kubectl commands in that context
            $ kubectl config set-context --current --namespace=kube-system

15.   Building Docker images
            $ docker login
            $ docker build -t <docker-id>/<name-of-the-repo>:<version>
            $ docker push <docker-id>/<name-of-the-repo>:<version>

16.   Create a Deployments for application
            $ vi ion-deployment.yaml
            $ kubectl apply -f ion-deployment.yml

17.   Create service for the deployment
            $ vi ion-service.yaml
            $ kubectl apply -f ion-service.yml

18.   To list deployments
            $ kubectl get deployments

19.   To list pods
            $ kubectl get pods

20.   To list services
            $ kubectl get services -o wide

21.   Open the browser and copy the IP address of master node  ,i.e  <master-node-ip>:<port-num>
      Note: Enable required <port-num> in Security groups for Master Node

22. To delete Deployments
            $ kubectl delete deployment ion-deployment

23. To delete Services
            $ kubectl delete service ion-service

24. To delete cluster
 	          $ export KOPS_STATE_STORE=s3://kub-ion-bucket-us-east-2
            $ kops delete cluster --name=kub.ion-app.thessadcloud.net --yes
