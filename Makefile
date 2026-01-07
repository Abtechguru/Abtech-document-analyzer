.PHONY: help up down build logs clean init test

help:
	@echo "Available commands:"
	@echo "  make up        - Start all services (detached)"
	@echo "  make up-dev    - Start dev services with logs"
	@echo "  make down      - Stop all services"
	@echo "  make build     - Rebuild all containers"
	@echo "  make logs      - View logs for all services"
	@echo "  make logs-backend - View backend logs"
	@echo "  make logs-frontend - View frontend logs"
	@echo "  make clean     - Stop and remove all containers, volumes"
	@echo "  make init      - Initialize database with sample data"
	@echo "  make test      - Run tests"
	@echo "  make shell-backend - Open shell in backend container"
	@echo "  make shell-frontend - Open shell in frontend container"

up:
	docker-compose up -d

up-dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

down:
	docker-compose down

build:
	docker-compose build --no-cache

logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

clean:
	docker-compose down -v --remove-orphans

init:
	chmod +x scripts/init-db.sh
	./scripts/init-db.sh

test:
	docker-compose exec backend pytest

shell-backend:
	docker-compose exec backend bash

shell-frontend:
	docker-compose exec frontend sh

migrate:
	docker-compose exec backend alembic revision --autogenerate -m "$(msg)"
	docker-compose exec backend alembic upgrade head