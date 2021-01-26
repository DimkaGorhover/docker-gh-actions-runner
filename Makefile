include .env
export $(shell sed 's/=.*//' .env)

dc=docker-compose \
	--project-name github-actions-runner \
	--env-file $(shell pwd)/.env \
	-f $(shell pwd)/docker-compose.yml

build:
	@DOCKER_BUILDKIT=1 docker build --rm --force-rm \
		--cpu-quota 800000 \
		--build-arg VERSION=$(VERSION) \
		-f $(shell pwd)/Dockerfile \
		-t dier/github-actions-runner:$(VERSION) \
		-t dier/github-actions-runner:latest \
		$(shell pwd)

run:
	$(dc) up -d
