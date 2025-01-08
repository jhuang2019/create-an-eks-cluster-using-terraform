# create-an-eks-cluster-using-terraform

This repo is used to introduce how to deploy a containerized application to AWS Elastic Kubernetes Service (EKS) with ArgoCD, GitHub Actions, and Terraform.
The entire lifecyle is achieved by a fully automated CI/CD process.


## References

## The technologies I used

* AWS resources, including EC2,VPC,IAM,EKS,and ECR.
* Argo CD auto sync policy
* GitHub Actions
* Terraform
* Shell script

## The architecture diagram

![Alt text](./images/diagram.png)

* The continuous integration(CI) includes the following steps:
  * Developers merges code to the main branch of the applicatio repo which includes docker files.
  * GitHub Actions webhook is triggered automatically due to the new code merge and a new build is started.
  * A new docker image is built with a new image tag.  I took github.sha as the new docker image tag.
  * The new docker image is pushed to Amazon ECR
  * The Kubernetes deployment manifest file called `deployment.yml` in the GitOps repo is also updated with the new image tag.
  
* The continuous deployment(CD) process includes the following steps
  * Argo CD will automatically synchronize the change in the `depoyment.yml` and deploy it to Amazon EKS.
 
* The entrie infrastructre including all aws resoures and Argo CD ise created by Terraform.
   
## Prerequisites

* Create a new aws account
* Create an IAM user in the new aws account created above with the details below.
  * User Name: `Administrator`
  * Custom password: Create your own password
  * Attach policies directly with the policy name called `AdministratorAccess`
* A locally configured AWS profile for the above IAM user `Administrator`
* All the AWS resources mentioined above are created in the IAM user account `Administrator`
* Install Terraform
* Install AWS CLI
* Install colima to run docker as I'm on Mac (m2 chip)
* Install kubectl
* Install argocd CLI
* Install jq

## Steps to implement the CI and CD process

### Step 1: Containerizing the Application with Docker
  
#### The application repo is saved in a standard alone project called `my-nginx`. The link is  https://github.com/jhuang2019/my-nginx

The Dockerfile contains the following code.

```docker
FROM --platform=linux/amd64 nginx:latest

COPY index.html /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g","daemon off;"]

```

#### The brief overview of what this Dockerfile does is below:

* Base image: It uses the official nginx:latest image as the foundation. I had to add `--platform=linux/amd64` as I got an error `exec /docker-entrypoint.sh: exec format error` when deploying my app to EKS. The root cause is that the image I genereated on my Mac with M2 chip is not compatible with Amazon EKS. So I had to use `--platform=linux/amd64` in order to tell Docker to specifically build for linux/amd64 when it is generating the image, so my docker image that is being built on MacOS will be compatible and deployable to Amazon EKS.
* Copy index.html file: Copies a self-created index.html from my host machine into the container default nginx directory `/usr/share/nginx/html`.
* Expose port 80: This allows access to the app via port 80 from outside the container.
* The `CMD` instruction: It specifies the default command to run when a container is started from the Docker image.The -g 'daemon off;' option is used to start the Nginx server in the foreground instead of as a background process when the container starts.

### Step 2: Writing Kubernetes Manifests for Your Application

### Step 3: Implementing Infrastructure as Code with Terraform

### Step 4: Deploying EKS and ArgoCD

#### VPC

#### EKS

#### Load Balancer

#### Deploying ArgoCD
  
### Step 5: Setting Up GitHub Actions

## Use Terraform to bootstrap both AWS resources and argocd

### Initialise the TF directory

```terraform
 terraform init

```

### Create an execution plan

```terraform
 terraform plan
 
```

### Execute terraform configuration

It takes around 15-20 mins to bootstrap all resources.

```terraform
 terraform apply --auto-approve
 
```

![Alt text](./images/terraform-apply-after.png)

### Verification steps

#### VPC verification

![Alt text](./images/vpc.png)

#### EC2 verification

![Alt text](./images/ec2.png)

#### EKS verification

![Alt text](./images/eks-two-nodes.png)

#### CI part verification

#### CD part verification

#### Kubectl to retrieve all pods

It shows that the pod `my-nginx`  has been deployed in the namespace `gitops-demo-2` and another pod `cluster-autoscaler` which is used to scale up pods has been deployed in the namespace `kube-system`

![Alt text](./images/kubectl-result.png)

### Cleanup resources

This needs to be improved in future. Currently, some manual steps below are required before running `terraform destroy`.

* Manually delete the argo app in the argocd UI.
* Manually run `kubectl delete ns argocd` so that `terraform destroy` wont get stuck in destroying the eks worker nodes.
* Manully remove all images in the ECR repo. Otherwise it wont allow the ecr repo to be deleted by Terraform.

```terraform
 terraform destroy
 
```

Please note one resource `argocd` has been manually deleted via kubectl commands, so the total number has been changed from 53 to 52.

![Alt text](./images/terraform-destroy.png)

## Issues I had and how I fixed them

### Issue 1: I got an error `exec /docker-entrypoint.sh: exec format error` when deploying my docker image to Amazon EKS.

The root cause is that the image I genereated on my Mac with M2 chip is not compatible with Amazon EKS.

How I fixed the issue is to add `--platform=linux/amd64`  to Dockerfile by referring to https://medium.com/block-imperium-games/exec-format-error-or-how-macs-m1s-docker-images-and-aws-ecs-eks-conspired-to-waste-a-weekend-6fcd2ea063d1.

So instead of putting

```docker
FROM nginx:latest

```

I have to specify

```docker
FROM --platform=linux/amd64 nginx:latest

```

### Issue 2: 