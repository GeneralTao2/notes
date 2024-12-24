## notes


### Build & Run
Make sure you have docker daemon started.
```
mvn clean spring-boot:build-image -DskipTests

docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

Run in Nomad cluster
```
sudo nomad agent -config=nomad/nomad-server.hcl -config=nomad/nomad-client.hcl

nomad job run nomad/notes-postgres.nomad.hcl

nomad job run nomad/notes-flyway.nomad.hcl

nomad job run nomad/notes-web.nomad.hcl 

// See IP address of the app
nomad node status -verbose \
    $(nomad job allocs notes-web | grep -i running | awk '{print $2}') | \
    grep -i ip-address | awk -F "=" '{print $2}' | xargs | \
    awk '{print "http://"$1":8080"}'

// See IP address of the db  
nomad node status -verbose \
    $(nomad job allocs notes-postgres | grep -i running | awk '{print $2}') | \
    grep -i ip-address | awk -F "=" '{print $2}' | xargs | \
    awk '{print "http://"$1":5432"}'
```

Open Nomad UI
http://localhost:4646/ui/jobs

You can open Nomad dir with datadir and logs using Visual Code, make sure you use your user name:
```
code /home/tao/nomad
```

Run in docker compose. Useful if you want to test your app and db fast:
```
docker compose -f docker-compose/docker-compose.yml up -d
```