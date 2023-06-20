# Deploying to AWS

To deploy `tenantee-app` on the AWS platform follow these steps:

1. First we will build an image on our local machine and upload it to ECR.
2. We will use ECS with one service and one task.
3. We will create an application loadbalancer which will route traffic and serve it through HTTPS (self-signed).

## Build an image localy

Before starting, create a Postgres DB in AWS, as well as an Elastic Cache Redis database,

To build the docker image on local machine, copy the `build.sh` script from the README.md in the project root and update the exports.
Run the script, and at the end of the build process you will receive the `SECRET_KEY_BASE` variable - save it somewhere.

## Push image to AWS ECR

To push the newly created image to AWS ECR first you have to setup your account.
In your terminal run `aws configure` and paste in your access key and secret access key from your AWS account.

In your AWS account create a private repository called tenantee-app.
Run `aws ecr get-login-password --region REGION_NAME | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.REGION_NAME.amazonaws.com` in terminal with
your REGION_NAME and ACCOUNT_ID.

Tag an image with `docker tag tenantee-app:latest ACCOUNT_ID.dkr.ecr.eu-central-1.amazonaws.com/tenantee-app:latest`,
and then push it to AWS with `docker push ACCOUNT_ID.dkr.ecr.eu-central-1.amazonaws.com/tenantee-app:latest`.

## Create the AWS application loadbalancer

Create an application loadbalancer called `tenantee-elb`.
Add 1 listener for port 443 - HTTPS protocol.

Create a target group. 
The type is `IP address` and the protocol and the port are HTTPS and 443
It will ask you to provide a `.pem` SSL key for HTTPS.
To do this you will first have to enter the docker container we have created, previously.
Run `docker exec -it container_id /bin/bash`.
Go to `/priv/cert` and copy the two files with the `.pem` extension.
Import them to the loadbalancer.

## Create the task

To create the task, go to ECS and create a new task definition with JSON.

Paste in the contents of `task-definition.json`, with changes to REGION_NAME and ACCOUNT_ID,
as well as your environment variables.

## Create the ECS cluster

In ECS, create a cluster called `tenantee-app`.
Then create a service called `tenantee-service`.
For the service choose the latest revision for the task-definition.
For networking select a security group that allows traffic on port 443.
And for the loadbalancer, select the one we have created previously.

## Done

In your browser paste in the loadbalancer endpoint and you should be greeted with Tenantee's
homepage.
