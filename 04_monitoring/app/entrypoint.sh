#!/bin/bash
set -e

# Function to wait for a service to be ready
wait_for_service() {
  local host=$1
  local port=$2
  local service_name=$3

  echo "Waiting for $service_name to be ready at $host:$port..."
  while ! wget -q --spider "http://$host:$port"; do
    echo "Still waiting for $service_name at $host:$port..."
    sleep 2
  done
  echo "$service_name is ready!"
}

# Debugging: Print environment variables
echo "PostgreSQL Host: $POSTGRES_HOST"
echo "PostgreSQL Port: $POSTGRES_PORT"
echo "Elasticsearch URL: $ELASTIC_URL"

# Wait for the PostgreSQL database to be ready
wait_for_service $POSTGRES_HOST $POSTGRES_PORT "PostgreSQL"

# Extract the host from the Elasticsearch URL
ELASTIC_HOST=$(echo $ELASTIC_URL | sed 's|http[s]*://||' | cut -d':' -f1)
ELASTIC_PORT=$(echo $ELASTIC_URL | sed 's|http[s]*://||' | cut -d':' -f2)

# Wait for Elasticsearch to be ready
wait_for_service $ELASTIC_HOST $ELASTIC_PORT "Elasticsearch"

# Initialize the database and Elasticsearch
python3 prep.py

# Execute the CMD
exec "$@"
