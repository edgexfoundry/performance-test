# environment variable
export grafanaHost=${grafanaHost}
export influxdbHost=${influxdbHost}

# Create jmeter database to InfluxDB
curl -i -XPOST http://${influxdbHost}:8086/query --data-urlencode "q=CREATE DATABASE jmeter"

# Import Grafana datasource
curl -X "POST" "http://${grafanaHost}:3000/api/datasources" -H "Content-Type: application/json" --user admin:admin --data-binary @datasource/jmeter-datasource.json
curl -X "POST" "http://${grafanaHost}:3000/api/datasources" -H "Content-Type: application/json" --user admin:admin --data-binary @datasource/telegraf-datasource.json

# Import Grafana Dashboard

