resource "kubernetes_config_map" "flyway_sql" {
  metadata {
    name = "flyway-sql"
  }

  data = {
    "V100000__create_tables.sql" = file("../flyway/sql/V100000__create_tables.sql")
  }
}

resource "kubernetes_config_map" "flyway_config" {
  metadata {
    name = "flyway-config"
  }

  data = {
    "flyway.conf" = file("../flyway/flyway.conf")
  }
}
