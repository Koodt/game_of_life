output "cluster_id" {
  value = selectel_dbaas_datastore_v1.datastore_1.id
}

output "cluster_status" {
  value = selectel_dbaas_datastore_v1.datastore_1.status
}

output "db_user" {
  value = selectel_dbaas_user_v1.dbaas_user.name
}

output "db_name" {
  value = selectel_dbaas_database_v1.database_1.name
}

output "master_host" {
  value = selectel_dbaas_datastore_v1.datastore_1.connections["master"]
}
