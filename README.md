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
| CloudSQL API                             | sqladmin.googleapis.com             |

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

For convenience purposes, make the Terraform service account Editor and Networks Admin on your project :
```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/editor"
```
and 
```sh
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/servicenetworking.networksAdmin"
```

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

