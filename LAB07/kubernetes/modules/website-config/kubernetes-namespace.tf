resource "kubernetes_namespace" "n" {
  metadata {
    name = "det-${var.project}-ns"
  }
}
