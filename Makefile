.PHONY: build start uninstall check csfixer phpstan behat security

DOCKER          = docker
DOCKER_COMPOSE  = docker-compose
PHP_SERVICE     = $(DOCKER_COMPOSE) exec php sh -c
CONSOLE         = $(DOCKER_COMPOSE) exec php bin/console

##
## ----------------------------------------------------------------------------
##   Environment
## ----------------------------------------------------------------------------
##

build: ## Build the environment
	$(DOCKER_COMPOSE) build

start: ## Start the environment
	$(DOCKER_COMPOSE) up -d --remove-orphans

uninstall: ## Uninstall the environment
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

php: ## Open a terminal in the "php" container
	$(DOCKER_COMPOSE) exec php sh

db: ## Open a terminal in the "db" container
	$(DOCKER_COMPOSE) exec db sh

##
## ----------------------------------------------------------------------------
##   Quality
## ----------------------------------------------------------------------------
##

check: ## Execute all quality assurance tools
	make csfixer phpstan behat security

csfixer: ## Run the PHP coding standards fixer on apply mode
	@test -f .php_cs || cp .php_cs.dist .php_cs && \
	php vendor/bin/php-cs-fixer fix --config=.php_cs \
		--cache-file=.php_cs.cache --verbose

phpstan: ## Run the PHP static analysis tool at level max
	php ./vendor/bin/phpstan analyse -l max src admin public

behat: ## Run the tests suit
	php ./vendor/bin/behat

security: ## Run a security analysis on dependencies
	php ./vendor/bin/security-checker security:check

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
		| sed -e 's/\[32m##/[33m/'
.PHONY: help