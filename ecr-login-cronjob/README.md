# Automate the process to login to the AWS ECR from a specific namespace of a kubernetes cluster

## Setup

If this is the first time installing the aws registry update mechanism follow the first step. Else, you can proceed to the next one.

### Create a docker image to deploy to public docker hub

1. Go to the `aws-kube` directory.
2. The Dockerfile will produce an image that contains the aws-cli and kubectl. This is needed to update the AWS ECR credentials periodically in a kubernetes cluster.
3. Build the docker image and tag it in such way to be able to pull it from the ecr-cron. i.e.

        docker build -t aws-kube:latest .

4. Don't forget to login and push the image to your account in the public Docker hub.

### Create a cronjob for kubernetes

The following approach has in mind that you need to do the process for a specific namespace.

An example for openfaas is already there. What you will not find in the openfaas directory is the `aws-secrets.yml`. You can copy one from the `templates` directory.

1. Create a directory for your application.
2. Copy the files from the `templates` directory to the new directory:

         aws-role.yml
         aws-secrets.yml.template
         aws.sh.template
         ecr-cron.yml

3. Go into the new directory
4. Rename `aws-secret.yml.template` to `aws-secret.yml`
5. Edit the `aws-role.yml` file and set the name to both ClusterRole and ClusterRoleBinding configurations. ie. name: openfaas-aws-authorization-cluster-role. 
This is necessary because ClusterRole and ClusterRoleBinding are not hiding behind a namespace and should have unique names.
6. Edit the `aws-secrets.yml` file and set your AWS credentials (as base64 values)
7. Edit the `ecr-cron.yml` and change the namespaces, the docker image to your aws-kube.
8. Rename `aws.sh.template` to `aws.sh` and make it an executable. 

        chmod +x aws.sh

9. Edit `aws.sh` and set the namespace
10. Run the `aws.sh` 

        ./aws.sh

If everything has been done successfully, you should be able to see the cron job with:

	kubectl get cronjobs -n MY_NAMESPACE

### A big thanks to @xynova

This is based on his work

