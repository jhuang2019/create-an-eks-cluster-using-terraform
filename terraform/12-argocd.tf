resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata{
    name = "argocd"
  }

  depends_on = [aws_eks_node_group.private_nodes]
}

resource "null_resource" "apply_argocd_manifest" {
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  }  

 depends_on = [kubernetes_namespace_v1.argocd_ns]
}

resource "null_resource" "create_lb"{
  provisioner "local-exec"{
    command = "sleep 100 && kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'"
  }

  depends_on = [null_resource.apply_argocd_manifest]
}

resource "time_sleep" "wait_300_seconds" {
  create_duration = "300s"

  depends_on = [null_resource.create_lb]
}

resource "null_resource" "get_argoserver_url" {
  provisioner "local-exec" {
    command = "kubectl get svc argocd-server -n argocd -o json | jq --raw-output .status.loadBalancer.ingress[0].hostname > ${path.module}/argoserver_url.txt"
  }

  depends_on = [time_sleep.wait_300_seconds]
}

resource "null_resource" "get_argoserver_pwd" {
  provisioner "local-exec" {
    command = " chmod +x ./get_argo_pwd.sh ; ${path.module}/get_argo_pwd.sh"
  }
  depends_on = [null_resource.get_argoserver_url]
}

resource "null_resource" "login_argocd" {
  provisioner "local-exec" {
    command = " chmod +x ./login_argocd.sh ; ${path.module}/login_argocd.sh"
  }
  depends_on = [null_resource.get_argoserver_pwd]
}
