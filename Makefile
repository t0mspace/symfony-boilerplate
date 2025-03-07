# Variables
DOCKER = docker
DOCKER_COMPOSE = docker compose
PHP_FPM_CONTAINER = php
CADDY_CONTAINER = caddy
EXEC = $(DOCKER) exec -it $(PHP_FPM_CONTAINER)
PHP = $(EXEC) php
COMPOSER = $(EXEC) composer
SYMFONY_CONSOLE = $(PHP) bin/console


cc: ## Clear cache
	$(SYMFONY_CONSOLE) cache:clear

## —— 🎻 Composer ——
composer-install: ## Install dependencies
	$(COMPOSER) install

composer-require: ## Add new depencencies
	$(COMPOSER) require $(ARGS)

composer-update: ## Update dependencies
	$(COMPOSER) update

composer-clear-cache: ## clear-cache dependencies
	$(COMPOSER) clear-cache


## —— 🐳 Docker —————————————————————————————————————————————————————————————————
build: ## Build app with Images
	$(DOCKER_COMPOSE) build

rebuild: ## Stops and removes containers, volumes, and orphaned networks, then rebuilds the services
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
	$(DOCKER_COMPOSE) up --build -d

start: ## Start the app
	$(DOCKER_COMPOSE) up -d

stop: ## Stop the app
	$(DOCKER_COMPOSE) stop

prune: ## Removes all unused volumes to free up space
	$(DOCKER_COMPOSE) down -v

logs: ## Display the container logs
	$(DOCKER_COMPOSE) logs -f

exec-php-fpm: ## Opens an interactive bash shell inside the php-fpm container
	$(DOCKER_COMPOSE) exec $(PHP_FPM_CONTAINER) bash

exec-caddy: ## Opens an interactive bash shell inside the php-fpm container
	$(DOCKER_COMPOSE) exec $(CADDY_CONTAINER) sh

## —— 🧪 Quality Tools —————————————————————————————————————————————————————————————————
phpcsf: ## Run PHP_CSfixer
	$(EXEC) vendor/bin/php-cs-fixer fix src --rules=@PSR12


phpstan: ## Run PHPStan analysis
	$(EXEC) vendor/bin/phpstan analyse -l max src

phpunit: ## Run PHPUnit tests
	$(EXEC) vendor/bin/phpunit $(ARGS)

## —— ⚙️  Others —————————————————————————————————————————————————————————————————
help: ## List of commands
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
