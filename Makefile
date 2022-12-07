current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SHELL = /bin/bash
docker-container = hotdog-webserver

CURRENT_UID := $(shell id -u)
export CURRENT_UID

#
# ❓ Help output
#
help: ## Show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_\-\/]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-24s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#
# 🐘 Build and run
#
start: ## Start and run project
	docker compose up -d

stop: ## Stop project
	docker compose down

install: ## Install dependencies
	docker exec $(docker-container) composer install

bash: ## Start bash console inside the container
##	docker exec --user=root  -it $(docker-container) /bin/bash
## docker exec --user=1001 -it hotdog-webserver /bin/bash
	docker exec --user=${CURRENT_UID} -it $(docker-container) /bin/bash


create-db/test:
	docker exec $(docker-container) php bin/console doctrine:database:create --env=test

migrate/dev:
	docker exec $(docker-container) php bin/console doctrine:migrations:migrate --env=dev

migrate/test:
	docker exec $(docker-container) php bin/console doctrine:migrations:migrate --env=test



#
# 🔬 Testing
#
test/all: ## Execute all tests
	docker exec $(docker-container) ./vendor/bin/phpunit --config phpunit.xml.dist

test/unit: ## Execute unit tests
	docker exec $(docker-container) ./vendor/bin/phpunit --config phpunit.xml.dist --testsuite Unit

test/integration: ## Execute integration tests
	docker exec $(docker-container) ./vendor/bin/phpunit --config phpunit.xml.dist --testsuite Integration

test/functional: ## Execute functional tests
	docker exec $(docker-container) ./vendor/bin/phpunit --config phpunit.xml.dist --testsuite Functional

#
# 💅 Style and errors
#
style/all: ## Analyse code style and possible errors
	docker exec $(docker-container) ./vendor/bin/php-cs-fixer fix --dry-run --diff --config .php-cs-fixer.dist.php
	docker exec $(docker-container) ./vendor/bin/phpstan analyse -c phpstan.neon.dist

style/code-style: ## Analyse code style
	docker exec $(docker-container) ./vendor/bin/php-cs-fixer fix --dry-run --diff --config .php-cs-fixer.dist.php

style/static-analysis: ## Find possible errors with static analysis
	docker exec $(docker-container) ./vendor/bin/phpstan analyse -c phpstan.neon.dist

style/fix: ## Fix code style
	docker exec $(docker-container) ./vendor/bin/php-cs-fixer fix --config .php-cs-fixer.dist.php
