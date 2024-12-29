resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata{
    name = "argocd"
  }
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