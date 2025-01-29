# README

* Ruby version
```
3.3.4
```

* Debug
```
docker exec -it app bash
```

* Database initialization
```
This image is depend on db image.
```

* Build & Run
```
docker build -f ./.docker/app/Dockerfile -t app .
docker run -d --rm --name app -p 3001:3001  --env-file .env app
```
