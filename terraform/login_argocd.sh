argocd_url=`cat argoserver_url.txt`
argocd_pwd=`cat argoserver_pwd.txt`
argocd login $argocd_url  --username admin --password $argocd_pwd  --insecure
echo "Login to ArgoCD server"