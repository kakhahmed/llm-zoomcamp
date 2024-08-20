import requests

ELASTIC_URL = "http://elasticsearch:9200"

try:
    response = requests.get(ELASTIC_URL)
    if response.status_code == 200:
        print("Successfully connected to Elasticsearch")
    else:
        print(f"Failed to connect to Elasticsearch, status code: {response.status_code}")
except Exception as e:
    print(f"Error connecting to Elasticsearch: {e}")