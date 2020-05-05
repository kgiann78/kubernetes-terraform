# Kubernetes playground with Terraform

Provision containers and more in Kubernetes (k8s) with Terraform. This is my journal recording the steps that I am using to this journey.

### Useful resources: 

Terraform - [Getting Started with Kubernetes provider](https://www.terraform.io/docs/providers/kubernetes/guides/getting-started.html)

Terraform - [Helm provider](https://www.terraform.io/docs/providers/helm/index.html)

## The goals

The goal for this journey will be to install [OpenFaaS](https://www.openfaas.com/), following the instructions for installation to Kubernetes from [faas-netes](https://github.com/openfaas/faas-netes) using [helm](https://github.com/openfaas/faas-netes/blob/77851960b31b980f0328d55fd0f8c2b168bac8b7/chart/openfaas/README.md).

## Requirements

The above goal requires to have already installed the following:

* a `k8s` cluster (i.e. minikube, k3s, microk8s etc)
* `helm`, OpenFaaS mentions to have also `tiller` along with `helm` (to be revised). 
* `terraform`

You can find a lot of information on how to install all the above in the given or elsewhere references.

Also, I am running `kubectl` remotely connecting to the cluster from a machine that has installed terraform. In order to achieve this copy the `~/.kube/config` file to the local `~/.kube/config` file (create if this doesn't exist). Note the address of the server of the cluster that you want to connect and change this server address if it is `localhost` or `127.0.0.1` in your file. 

You also may have to open the `16443` port from your remote server so that you can connect.

You can avoid this if you use the instructions in the Terraform Kubernetes provider, where you can use credentials or basic authentication to connect.

## Notes

* In `terraform.tfvars` we can add env vars to use in scripts. Copy `terraform.tfvars.sample` to `terraform.tfvars` and update the values to use in variables or other resources.
* At any point you can run `terraform init` to download the providers and check if anything is good to go. When all scripts are ready, run the `start` script to fire-up the installation.
* In the `helm_release` resource, we are using the setting `generateBasicAuth=false`. This will install `openfaas` without creating the basic authentication. Instead we will create custom credentials and will store them as secrets:

        # generate a random password	
        PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)	
        kubectl -n openfaas create secret generic basic-auth \
        --from-literal=basic-auth-user=admin \
        --from-literal=basic-auth-password="$PASSWORD"	

    This can also pass into the `terraform` scripts in the future.

* In case we need to edit the values for the terraform chart we can download them for inspection:

        helm inspect values openfaas/openfaas > openfaas_values.yml
    
    After editing values we can add them in the openfaas helm_release resource:

        values = [
            "${file("${VALUES_PATH}/openfaas_values.yml")}"
        ]