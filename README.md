# tutorial-private-cloud-sql-bq-connection
Instantiate a CloudSQL instance in a Private VPC and connect through BigQuery

## I - Useful links

- Kaggle data used to feed CloudSQL table : https://www.kaggle.com/datasets/ankanhore545/100-highest-valued-unicorns

## II - Setup

In your GCP project, enable the following APIs :

| Name                                     | Google API Services                 |
|------------------------------------------|-------------------------------------|
| Cloud Storage API                        | storage.googleapis.com              |
| Bigquery API                             | bigquery.googleapis.com             |
| Bigquery Connection API                  | bigqueryconnection.googleapis.com   |
| Cloud Resource Manager API               | cloudresourcemanager.googleapis.com |
| Service Networking API                   | servicenetworking.googleapis.com    |
| CloudSQL Admin API                       | sqladmin.googleapis.com             |

Before starting, export a few environement variables to ease the further actions :
```sh
export PROJECT_ID=<your Google Cloud project ID>
export TERRAFORM_SA_NAME=terraform-deployer
```

Initiate your ```gcloud``` SDK configuration :
```sh
gcloud init
```

Create a service account to execute Terraform code :
```sh
gcloud iam service-accounts create ${TERRAFORM_SA_NAME} \
    --description="Service account used to deploy platform with Terraform" \
    --display-name="Terraform deployer"
```

From the console you should get the following succes message : 
```Created service account [terraform-deployer].```

Create and download a key associated with it :
```sh
gcloud iam service-accounts keys create my-key.json \
    --iam-account="${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
```

You should get the following prompt : 
```created key [***] of type [json] as [my-key.json] for [terraform-deployer@***.iam.gserviceaccount.com]```

Export the so called ```GOOGLE_APPLICATION_CREDENTIALS``` environment variable to match your created key file :
```sh
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/my-key.json
```

In order to conform to the least-priviledge principle, create a custom role containing the necessary permissions for Terraform to apply :
:warning: ```You'll need the following role : roles/iam.roleAdmin``` :warning:
```sh
export ROLE_ID=cloudsqlbq_terraform_builder
gcloud iam roles create ${ROLE_ID} --project=${PROJECT_ID} --file=terraform_custom_role.yaml
```

You may get the following message, nothing serious, just keep it in mind :
```sh
Note: permissions [compute.subnetworks.get] are in 'TESTING' stage which means the functionality is not mature and they can go away in the future. This can break your workflows, so do not use them in production systems!
```

Bind your custom role :
```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="projects/${PROJECT_ID}/roles/${ROLE_ID}"
```

The following role need to be bind also. The stacktrace associated with denied permissions did not provide accurate insights on what permission
was missing. This still needs to be improved :

```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/cloudsql.admin"
```

```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/servicenetworking.networksAdmin"
```

:warning: This does not respect the least-priviledges principle. If you want to respect it, do not do these bindings, apply Terraform
and add the required permissions to a custom role. Do not hesitate to open a PR to improve this. :warning:

Initiate your ```terraform``` configuration :
```sh
cd terraform
```
and 

```sh
terraform init
```

:warning: Please be aware that the Terraform state is local. No Cloud synchronization is made here. :warning:

If you want, look at the execution plan :
```sh
terraform plan -var="project_id=${PROJECT_ID}"
```

And apply your changes : 
```sh
terraform apply -var="project_id=${PROJECT_ID}" -auto-approve
```

To destroy your platform :
```sh
terraform destroy -var="project_id=${PROJECT_ID}" -auto-approve
```
