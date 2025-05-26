docker rm -f `docker ps -a -q --filter name='postgre-opendid'`
docker volume rm postgre_postgre_opendid_data
