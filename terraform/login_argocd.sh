argocd_url=`cat argoserver_url.txt`
argocd_pwd=`cat argoserver_pwd.txt`
echo "Login to ArgoCD server"
argocd login $argocd_url  --username admin --password $argocd_pwd  --insecure
echo "Retrieve the ArgoCD application list"
argocd app list

CONTEXT_NAME=`kubectl config view -o jsonpath='{.contexts[].name}'`
app_name="gitops-demo-2"
project_name="default"
git_repo="https://github.com/jhuang2019/gitops-apps"
git_path="./simple-app"
dest_namespace="gitops-demo-2"

echo "Add the EKS cluster which was created by Terraform to ArgoCD"
argocd cluster add --yes  $CONTEXT_NAME
k8s_cluster=`argocd cluster list |grep eks |awk '{print $1}'`

echo "App name is $app_name"
echo "Project Name is $project_name"
echo "Git repo is $git_repo"
echo "Git path is $git_path"
echo "K8S cluster is $k8s_cluster"
echo "Dest namespace is $dest_namespace"

echo "Create a namespace called $dest_namespace"
kubectl create namespace $dest_namespace

echo "Create an app with ArgoCD CLI"
argocd app create $app_name \
--project $project_name \
--repo $git_repo \
--path $git_path \
--dest-server $k8s_cluster \
--dest-namespace $dest_namespace \

echo "Retrieve the ArgoCD application list again"
argocd app list

echo "Sync the ArgoCD application"
argocd app sync $app_name