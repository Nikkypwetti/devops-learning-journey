Lab 2: Multi-Service Application
🎯 Objective

Create a complete application with multiple services working together.
🚀 Exercises
Exercise 1: Web + Database

Create compose.yaml:

yaml

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp
      POSTGRES_USER: appuser
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:

Exercise 2: Flask + Redis Counter

Create app.py:
python

import time
import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError:
            if retries == 0:
                raise
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return f'Hello World! I have been seen {count} times.\n'

Create requirements.txt:
text

flask
redis

Create Dockerfile:
dockerfile

FROM python:3.11-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run", "--host=0.0.0.0"]

Create compose.yaml:
yaml

services:
  web:
    build: .
    ports:
      - "8000:5000"
    environment:
      FLASK_APP: app.py
      FLASK_RUN_HOST: 0.0.0.0
  
  redis:
    image: "redis:alpine"

Run:
bash

docker compose up -d
curl http://localhost:8000  # Count increases each time

Exercise 3: WordPress + MySQL
yaml

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress-data:/var/www/html
  
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    volumes:
      - db-data:/var/lib/mysql

volumes:
  wordpress-data:
  db-data:

✅ Success Criteria

    Can run applications with multiple services

    Understand service dependencies

    Can access services across containers

    Know how to persist data with volumes