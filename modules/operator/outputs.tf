output "operator_namespace" {
  description = "Namespace where the operator is installed"
  value       = kubernetes_namespace.materialize.metadata[0].name
}

output "operator_release_name" {
  description = "Helm release name of the operator"
  value       = helm_release.materialize_operator.name
}

output "operator_release_status" {
  description = "Status of the helm release"
  value       = helm_release.materialize_operator.status
}

output "materialize_instances" {
  description = "Details of created Materialize instances"
  value = {
    for name, instance in kubernetes_manifest.materialize_instances : name => {
      id        = instance.manifest.metadata.name
      namespace = instance.manifest.metadata.namespace
    }
  }
}

output "workload_identity_sa_email" {
  description = "Email of the GCP service account for workload identity"
  value       = var.workload_identity_sa_email
}
