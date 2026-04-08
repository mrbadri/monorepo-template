.PHONY: help build dev dev-up dev-down dev-down-v prod prod-up prod-down prod-down-v prod-logs dev-env prod-env

# Docker image name for web app
IMAGE_NAME := web-monorepo-web:latest

# Default target
.DEFAULT_GOAL := help

## Show this help
help:
	@echo ""
	@echo "\033[1;36mWeb monorepo\033[0m - Docker commands"
	@echo ""
	@echo "  \033[1;33mBuild\033[0m"
	@echo "    \033[32mmake build\033[0m      Build web image (web-monorepo-web:latest)"
	@echo ""
	@echo "  \033[1;33mDevelopment\033[0m (docker/dev)"
	@echo "    \033[32mmake dev\033[0m        Start dev env (creates .env if missing)"
	@echo "    \033[32mmake dev-up\033[0m     Start dev containers (foreground, \033[1m--build\033[0m)"
	@echo "    \033[32mmake dev-down\033[0m   Stop dev containers"
	@echo "    \033[32mmake dev-down-v\033[0m Stop dev containers and remove volumes"
	@echo ""
	@echo "  \033[1;33mProduction\033[0m (docker/prod)"
	@echo "    \033[32mmake prod\033[0m       Start prod env (creates .env if missing)"
	@echo "    \033[32mmake prod-up\033[0m    Start prod containers (detached)"
	@echo "    \033[32mmake prod-down\033[0m  Stop prod containers"
	@echo "    \033[32mmake prod-down-v\033[0m Stop prod containers and remove volumes"
	@echo "    \033[32mmake prod-logs\033[0m  Stream production logs"
	@echo ""

## Build
build:
	docker build -t $(IMAGE_NAME) -f apps/web/Dockerfile .
	@echo "Built $(IMAGE_NAME)"

## Dev environment (docker/dev)
dev: dev-env dev-up

dev-env:
	@if [ ! -f docker/dev/.env ]; then cp docker/dev/.env.example docker/dev/.env && echo "Created docker/dev/.env"; fi

dev-up:
	cd docker/dev && docker compose up --build

dev-down:
	cd docker/dev && docker compose down

dev-down-v:
	cd docker/dev && docker compose down -v

## Production environment (docker/prod)
prod: prod-env prod-up

prod-env:
	@if [ ! -f docker/prod/.env ]; then cp docker/prod/.env.example docker/prod/.env && echo "Created docker/prod/.env"; fi

prod-up:
	cd docker/prod && docker compose up -d --build
prod-down:
	cd docker/prod && docker compose down

prod-down-v:
	cd docker/prod && docker compose down -v

prod-logs:
	cd docker/prod && docker compose logs -f
