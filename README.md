# gcr-gc
A Helm chart to handle Google Container Registry Garbage Collection (GCR GC)

To use this, a GCP service account must be created with the `storage.buckets.get, storage.objects.delete, storage.objects.get, storage.objects.list` roles.

#### Example to create a service account and apply strict object roles to Google Container Registry bucket
```bash
gcloud beta iam service-accounts create gcr-gc \
    --description "Google Container Registry Garbage Collection" \
    --display-name "GCR-GC"

# Add viewer rights to service account so we can get/list resources
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member serviceAccount:gcr-gc@$(gcloud config get-value project).iam.gserviceaccount.com \
  --role roles/viewer

# Add specific admin roles to Container Registry bucket
gsutil iam ch serviceAccount:gcr-gc@$(gcloud config get-value project).iam.gserviceaccount.com:objectAdmin gs://eu.artifacts.$(gcloud config get-value project).appspot.com

gcloud iam service-accounts keys create key.json \
 --iam-account gcr-gc@$(gcloud config get-value project).iam.gserviceaccount.com

kubectl create secret generic gcr-gc-svc-acct \
 --from-file=key.json

rm -rf key.json
```