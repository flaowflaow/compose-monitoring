# compose-monitoring
Docker Compose for basic monitoring

## Services :

  - MongoDB:latest ----------------- https://hub.docker.com/_/mongo
  - Opensearch:latest  ----------------- https://hub.docker.com/r/opensearchproject/opensearch
  - Graylog:6.1  ----------------- https://hub.docker.com/r/graylog/graylog
  - Grafana:latest ----------------- https://hub.docker.com/r/grafana/grafana
  - Prometheus:latest  ----------------- https://hub.docker.com/r/prom/prometheus
  - Node_exporter:latest ----------------- https://hub.docker.com/r/prom/node-exporter
  - cAdvisor:latest  ----------------- https://hub.docker.com/r/google/cadvisor

## Prerequisites

SSH connection to the docker server

Use of a password generator to generate complex random passwords

You work in the ./docker repository


## Instructions :

From your working path execute : 

>git clone https://github.com/flaowflaow/compose-monitoring

Run the .env file generation script with the command 

>sudo bash generate.env.sh

⚠️ Use only alphanumeric characters when generating passwords and paste them in your terminal⚠️ 

Run the compose file with the command

>sudo docker compose up -d


# Enjoy 🙃 
