ARG FRANKENPHP_VERSION=1.12.2
ARG PHP_VERSION=8.5.5
ARG DISTRO=trixie

# ── base ─────────────────────────────────────────────────────────────────────
# install-php-extensions is bundled in the FrankenPHP image.
FROM dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP_VERSION}-${DISTRO} AS base

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime \
    && echo UTC > /etc/timezone \
    && install-php-extensions \
        bcmath \
        bz2 \
        gd \
        gettext \
        intl \
        pdo_mysql \
        redis \
        zip \
    && apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
