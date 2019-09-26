.PHONY: default release

DOCKER_REPO = eu.gcr.io/sthlmio-public-images/gcr-gc

default: release

# make release VER=0.1.0-alpha.0
release:
    sed -i -e "s/^\(\s*version\s*:\s*\).*/\1 ${VER}/" chart/gcr-gc/Chart.yaml
    sed -i -e "s/^\(\s*appVersion\s*:\s*\).*/\1 ${VER}/" chart/gcr-gc/Chart.yaml
    cd chart && helm package gcr-gc
    cd chart && gsutil cp gs://charts.sthlm.io/index.yaml index_current.yaml
    cd chart && helm repo index --merge index_current.yaml .
    gsutil cp chart/gcr-gc-${VER}.tgz gs://charts.sthlm.io
    gsutil cp chart/index.yaml gs://charts.sthlm.io
