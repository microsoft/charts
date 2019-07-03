#!/bin/sh
set -e
set -o pipefail

WORKING_DIRECTORY="$PWD"
HELM_VERSION=2.8.1
HELM_CHARTS_SOURCE="$WORKING_DIRECTORY/charts"
GITHUB_PAGES_BRANCH="gh-pages"
REPO_PATH="$WORKING_DIRECTORY/repo"

echo '>> Prepare...'
mkdir -p /tmp/helm/bin
mkdir -p /tmp/helm/publish
apk update
apk add ca-certificates git openssh
git checkout master

# run py script to fetch charts from repos
apk add python3
mkdir -p "charts"
mkdir -p "/tmp/sources/"
python3 -m pip install pyyaml
python3 .circleci/fetch_charts.py

ls -al

echo '>> Installing Helm...'
cd /tmp/helm/bin
wget "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxf "helm-v${HELM_VERSION}-linux-amd64.tar.gz"
chmod +x linux-amd64/helm
alias helm=/tmp/helm/bin/linux-amd64/helm
helm version -c
helm init -c

mkdir -p "$HOME/.ssh"
ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts"

cd $REPO_PATH
echo '>> Building charts...'
find "$HELM_CHARTS_SOURCE" -mindepth 1 -maxdepth 1 -type d | while read chart; do
  echo ">>> helm lint $chart"
  helm lint "$chart"
  chart_name="`basename "$chart"`"
  echo ">>> helm package -d $chart_name $chart"
  mkdir -p "$chart_name"
  helm package -d "$chart_name" "$chart"
done

echo '>>> helm repo index'
helm repo index .
ls $REPO_PATH

cd $WORKING_DIRECTORY
python3 -m http.server 8080 &

#wait for server to start running
sleep 10
helm repo add microsoft http://localhost:8080/repo
helm repo update

# inspect all by repo name
helm search microsoft -l |  sed 1d | while read chart_name chart_version app_version desc; do
  echo ">>> helm inspect $chart_name"
  helm inspect $chart_name
done

# inspect all by folder name
#find "$REPO_PATH" -mindepth 1 -maxdepth 1 -type d | while read chart; do
#  chart_name="`basename "$chart"`"
#  echo ">>> helm inspect microsoft/$chart_name"
#  helm inspect microsoft/"$chart_name"
#done

# echo ">> Publishing to $GITHUB_PAGES_BRANCH branch of $GITHUB_PAGES_REPO"
# git checkout -b $GITHUB_PAGES_BRANCH
# git config user.email "$CIRCLE_USERNAME@users.noreply.github.com"
# git config user.name CircleCI
# git add .
# git status
# git commit -m "Published by CircleCI $CIRCLE_BUILD_URL"
# git push -f origin "$GITHUB_PAGES_BRANCH"
# echo "done "
