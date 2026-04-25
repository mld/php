# php containers

Docker base images for PHP applications.

## Images

### `php`

Based on the official `php-fpm` image. Extensions included: `bcmath`, `bz2`, `gd`, `gettext`, `intl`, `pdo_mysql`, `redis`, `zip`, plus the `unzip` system package. Timezone set to UTC.

| Tag | PHP | Distro |
|-----|-----|--------|
| `7.4-base`, `7.4.33-base` | 7.4.33 | bullseye |
| `7.4-ci`, `7.4.33-ci` | 7.4.33 | bullseye |
| `8.5-base`, `8.5.5-base` | 8.5.5 | trixie |

The `ci` flavor adds Composer and globally installs: PHPUnit, PHPStan, PHPCS + PHPCompatibility, PHPMD, phploc, phpcpd, and php-parallel-lint.

### `frankenphp`

Based on `dunglas/frankenphp`. Same extensions as the `php` base image.

| Tag | FrankenPHP | PHP | Distro |
|-----|------------|-----|--------|
| `8.5-base`, `8.5.5-base` | 1.12.2 | 8.5.5 | trixie |

## Building locally

```sh
make build-all      # build all images
make push-all       # build and push to registry

# individual targets
make php-7.4-base
make php-7.4-ci
make php-8.5-base
make frankenphp-8.5-base
```

Override versions at build time:

```sh
make php-8.5-base PHP85_VERSION=8.5.6 DISTRO=trixie
make frankenphp-8.5-base FRANKENPHP_VERSION=1.13.0
```

## CI

GitHub Actions builds and pushes on every push to `main`. Pull requests build but do not push. Each image is tagged with both the minor version (`8.5-base`) and the patch version (`8.5.5-base`), plus a SHA-pinned tag for traceability (`8.5-base-<sha>`).
