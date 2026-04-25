REGISTRY           ?= ghcr.io
ORG                ?= mld
DISTRO             ?= trixie
# PHP 7.4 is EOL; trixie images do not exist upstream for it.
PHP74_DISTRO       ?= bullseye
FRANKENPHP_VERSION ?= 1.12.2
PHP74_VERSION      ?= 7.4.33
PHP85_VERSION      ?= 8.5.5

.PHONY: build-all push-all \
        php-7.4-base php-7.4-ci \
        php-8.5-base \
        frankenphp-8.5-base

build-all: php-7.4-base php-7.4-ci php-8.5-base frankenphp-8.5-base

# ── php ──────────────────────────────────────────────────────────────────────

php-7.4-base:
	docker build \
		--build-arg PHP_VERSION=$(PHP74_VERSION) \
		--build-arg DISTRO=$(PHP74_DISTRO) \
		--target base \
		-t $(REGISTRY)/$(ORG)/php:7.4-base \
		-t $(REGISTRY)/$(ORG)/php:$(PHP74_VERSION)-base \
		-f php/Dockerfile \
		.

php-7.4-ci: php-7.4-base
	docker build \
		--build-arg PHP_VERSION=$(PHP74_VERSION) \
		--build-arg DISTRO=$(PHP74_DISTRO) \
		--target ci \
		-t $(REGISTRY)/$(ORG)/php:7.4-ci \
		-t $(REGISTRY)/$(ORG)/php:$(PHP74_VERSION)-ci \
		-f php/Dockerfile \
		.

php-8.5-base:
	docker build \
		--build-arg PHP_VERSION=$(PHP85_VERSION) \
		--build-arg DISTRO=$(DISTRO) \
		--target base \
		-t $(REGISTRY)/$(ORG)/php:8.5-base \
		-t $(REGISTRY)/$(ORG)/php:$(PHP85_VERSION)-base \
		-f php/Dockerfile \
		.

# ── frankenphp ───────────────────────────────────────────────────────────────

frankenphp-8.5-base:
	docker build \
		--build-arg FRANKENPHP_VERSION=$(FRANKENPHP_VERSION) \
		--build-arg PHP_VERSION=$(PHP85_VERSION) \
		--build-arg DISTRO=$(DISTRO) \
		--target base \
		-t $(REGISTRY)/$(ORG)/frankenphp:8.5-base \
		-t $(REGISTRY)/$(ORG)/frankenphp:$(PHP85_VERSION)-base \
		-f frankenphp/Dockerfile \
		.

# ── push ─────────────────────────────────────────────────────────────────────

push-all: build-all
	docker push $(REGISTRY)/$(ORG)/php:7.4-base
	docker push $(REGISTRY)/$(ORG)/php:$(PHP74_VERSION)-base
	docker push $(REGISTRY)/$(ORG)/php:7.4-ci
	docker push $(REGISTRY)/$(ORG)/php:$(PHP74_VERSION)-ci
	docker push $(REGISTRY)/$(ORG)/php:8.5-base
	docker push $(REGISTRY)/$(ORG)/php:$(PHP85_VERSION)-base
	docker push $(REGISTRY)/$(ORG)/frankenphp:8.5-base
	docker push $(REGISTRY)/$(ORG)/frankenphp:$(PHP85_VERSION)-base
