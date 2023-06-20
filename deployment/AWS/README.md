# Deploying to AWS

To deploy `tenantee-app` on AWS platform follow these steps:

1. First we will build an image in our local machine and upload it to ECR.
2. We will use ECS with one service and one task running.
3. We will create application loadbalancer which will route traffic and serve it true secure protocol 443 listener.

### Build an image localy

To build docker image on local machine run `build.sh` script with updated environmets with DATABASE_URL and REDIS_URL.
First create postgres database in AWS called tenantee and username and password is postgres.
Create elastic cache redis batabase with password auth.
In `build.sh` file paste the endpoints for both databases.
Run the script.
At the end of the build process you will receive SECRET_KEY_BASE key - save it somewhere.

### Push image to AWS ECR

To push newly created image to AWS ECR first you have to setup your account.
In your terminal run `aws configure` and paste in your access key and secret access key for your AWS account.
In your AWS account create a private repository called tenantee-app.
Run `aws ecr get-login-password --region REGION_NAME | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.REGION_NAME.amazonaws.com` in terminal with changes to REGION_NAME and ACCOUNT_ID.
Next tag an image with `docker tag tenantee-app:latest ACCOUNT_ID.dkr.ecr.eu-central-1.amazonaws.com/tenantee-app:latest`.
And then push it to AWS with `docker push ACCOUNT_ID.dkr.ecr.eu-central-1.amazonaws.com/tenantee-app:latest`.

### Create AWS application loadbalancer

Create application loadbalancer called `tenantee-elb`.
Create 1 listener for port 443 - HTTPS protocol.
Create target group type is Ip address and protocol and port are HTTPS 443
It will ask you to provide .pem SSL key for HTTPS protocol.
To do this you will first have to exec to docker container we have created.
Run `docker exec -it container_id /bin/bash`.
Go to folder /priv/cert and cat the two files with .pem extension.
Paste in the AWS private key and body .pem file.

### Create task-definition.json with JSON

Paste in the content from `task-definition.json` file with some changes.

### Create ECS cluster

First create ECS cluster called `tenantee-app`.
Then create service called `tenantee-service`.
For service choose latest revision for task-definition.
For networking select security group that has access for port 443.
And for loadbalancer select loadbalancer we have created.

### Run the application

In your browser paste in the loadbalancer endpoint and tenantee application will be displayed.