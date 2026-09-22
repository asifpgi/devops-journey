# Docker DevOps Portfolio App

A multi-container application built to demonstrate practical Docker and Docker Compose skills.

## Architecture

Browser / Client
↓
Nginx Frontend
↓
Flask Backend
↓
Redis

## Technologies

* Docker
* Docker Compose
* Nginx
* Python / Flask
* Redis

## Features

* Custom Flask backend image built with a Dockerfile
* Nginx reverse proxy
* Docker Compose multi-service orchestration
* Automatic service-to-service DNS
* Environment variables
* Redis persistent named volume
* Container health checks
* Restart policies
* Port publishing
* Persistent application data

## Services

### Frontend

Nginx serves the web interface and reverse-proxies API requests to the backend service.

### Backend

Flask provides the `/api` and `/health` endpoints.

The API increments a visit counter stored in Redis.

### Redis

Redis stores the persistent visit counter using a Docker named volume.

## Start the Application

```bash
docker compose up -d --build
```

## Check Services

```bash
docker compose ps
```

## Test the API

```bash
curl http://localhost:8082/api
```

Example:

```json
{
  "message": "Hello from Asif's Docker DevOps Project",
  "visits": 5
}
```

## View Logs

```bash
docker compose logs
```

Or for a specific service:

```bash
docker compose logs backend
```

## Stop the Application

```bash
docker compose down
```

The Redis data remains persistent because the named volume is not removed.

To remove the containers and persistent volume:

```bash
docker compose down -v
```

## Skills Demonstrated

This project demonstrates Docker image creation, container networking, service discovery, reverse proxy configuration, persistent storage, health monitoring, environment configuration, and multi-container application orchestration.
