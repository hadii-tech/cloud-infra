echo 'Creating repo'; 
curl --location --request PUT http://$ELASTICSEARCH_SERVICE_HOST:9200/_snapshot/$ES_SNAPSHOTS_REPO --header 'Content-Type: application/json' -d @/opt/bitnami/elasticsearch/config/create_repo.json; 
echo 'Taking snapshot'; 
curl -X PUT $ELASTICSEARCH_SERVICE_HOST:9200/_snapshot/$ES_SNAPSHOTS_REPO/$(date +%F)?pretty;
echo 'sleeping..' 
sleep 3600