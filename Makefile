.PHONY: build up down logs shell notebook help

help:
	@echo "Available commands:"
	@echo "  make build          Build the Docker image"
	@echo "  make up             Start the Docker container"
	@echo "  make down           Stop and remove the Docker container"
	@echo "  make logs           View Docker logs"
	@echo "  make shell          Access container shell"
	@echo "  make notebook       Start Jupyter notebook"

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

shell:
	docker-compose exec lonboard-app bash

notebook:
	docker-compose exec lonboard-app jupyter notebook list

clean:
	docker-compose down -v
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
