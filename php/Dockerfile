ARG PHP_VERSION=8.5.5
ARG DISTRO=trixie

# ── base ─────────────────────────────────────────────────────────────────────
FROM php:${PHP_VERSION}-fpm-${DISTRO} AS base

ENV TZ=UTC

# install-php-extensions handles all system library dependencies automatically.
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/install-php-extensions
RUN chmod +x /usr/local/bin/install-php-extensions \
    && ln -snf /usr/share/zoneinfo/UTC /etc/localtime \
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

# ── ci ───────────────────────────────────────────────────────────────────────
FROM base AS ci

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV COMPOSER_HOME=/composer
ENV PATH=/composer/vendor/bin:$PATH

RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/zz-memory-limit.ini \
    && composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true \
    && composer global require --no-interaction --no-progress \
        "squizlabs/php_codesniffer=*" \
        "dealerdirect/phpcodesniffer-composer-installer=*" \
        "phpcompatibility/php-compatibility=*" \
        "phpcompatibility/phpcompatibility-paragonie=*" \
        "phpunit/phpunit=*" \
        "phpmd/phpmd=*" \
        "phploc/phploc=*" \
        "sebastian/phpcpd=*" \
        "phpstan/phpstan=*" \
        "phpstan/phpstan-php-parser=*" \
        "php-parallel-lint/php-parallel-lint" \
        "php-parallel-lint/php-console-highlighter=*" \
    && rm -rf /tmp/*
