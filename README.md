    $ docker build . -t jacobo/pg-rails
    $ docker run -p 5000:5000 jacobo/pg-rails

Setup the DB:
  1. Storage Class
  
      k create -f k8s_manifests/db-storage-class.yaml
      k get storageclasses
      k describe storageclass/pg-pv

  2. Volume Claim
  
      k create -f k8s_manifests/db-volume-claim.yaml
      k get pvc
      k describe pvc/pg-pv-claim

  2. Secret
  
      erb -r base64 -r securerandom k8s_manifests/db-secret.yaml | kubectl create -f -
      k get secret/pg-db-secret -o jsonpath="{.data.postgres-password}" | base64 --decode

  3. Deployment
 
      k create -f k8s_manifests/db-deployment.yaml
      
      root@pg-for-pg-rails-732073437-tw4vq:/# mount | grep post
      /dev/xvdba on /var/lib/postgresql/data type ext4 (rw,relatime,data=ordered)

  4. Service
 
      k create -f k8s_manifests/db-service.yaml
      
      #Go into a new container and connect to your running postgres
      k run debug -it --rm --image=postgres --restart=Never -- bin/bash
          $ psql -h pg-rails-service -U postgres
      
      #or connect via already running container
      k exec -it pg-for-pg-rails-732073437-db1nf


----

k run busybox -it --image=busybox --restart=Never -- bin/bash
k get pods -a
k delete busybox


----

  Let's get to automatically rolling back deployments! (via readiness checks)

  Stateful sets (best practice for databases)

  Let's get init containers working...