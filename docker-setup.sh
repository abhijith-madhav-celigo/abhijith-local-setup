#! /bin/bash

# Mongo
# Attach volume so that data is not lost when container is restarted
docker run --name integrator-mongo -d -p 27017:27017 \
	-v /Users/abhijithmadhav/work/mongo_data:/data/db mongo:latest

# redis
docker run --name integrator-redis -d -p 6379:6379 redis

# confluent kafka eco-system
docker compose -f kafka-stack-docker-compose/full-stack.yml up -d
