# Docker PHP Extensions

This project provides pre-compiled PHP extension Docker images, designed to make installing PHP extensions fast and lightweight. 

By using these pre-compiled images, you can avoid long build times and heavy dependencies (like `build-base`, `autoconf`, `gcc`, etc.) in your final production images.

## 🚀 How it works

Each extension is built into an Alpine-based Docker image. During the build, we extract:
1. The compiled `.so` extension file.
2. The necessary shared libraries (`.so`) that the extension depends on.
3. A pre-configured `.ini` file to enable the extension.

These artifacts are stored in `/opt/php/` within the extension image, allowing you to easily `COPY` them into your own Docker images.

## 📦 Usage

To use an extension in your `Dockerfile`, simply copy the files from the corresponding extension image.

### Example: Installing `gd` and `redis` for PHP 8.3

```dockerfile
FROM php:8.3-alpine

# Copy extensions and their dependencies from pre-compiled images
COPY --from=dockerphpext/gd:php8.3-alpine /opt/php/ /opt/php/
COPY --from=dockerphpext/redis:php8.3-alpine /opt/php/ /opt/php/
```

*Note: Docker images are hosted on Docker Hub under the [dockerphpext](https://hub.docker.com/u/dockerphpext) user.*

## 🛠 Supported Extensions

Currently, we support the following extensions for PHP versions **8.0, 8.1, 8.2, 8.3, 8.4, and 8.5**:

- `bcmath`, `calendar`, `exif`, `gd`, `gettext`, `gmp`, `grpc`, `igbinary`, `imagick`, `imap`, `intl`, `ldap`, `memcache`, `memcached`, `mongodb`, `msgpack`, `mysqli`, `opcache`, `pcntl`, `pcov`, `pdo_mysql`, `pdo_pgsql`, `protobuf`, `redis`, `sockets`, `sodium`, `uuid`, `xdebug`, `xmlrpc`, `xsl`, `yaml`, `zip`

*(Check the `extensions/` directory for the most up-to-date list.)*

## 🔨 Local Development

You can build and test extensions locally using the provided `Makefile`.

### Build an extension
```bash
make build extension=redis php_version=8.3
```

### Run tests for an extension
```bash
make run-single-test extension=redis php_version=8.3
```

### Run tests for all versions of an extension
```bash
make run-test extension=redis
```

## 🏗 Project Structure

- `extensions/`: Contains Dockerfiles for each extension and PHP version.
- `scripts/`: Helper scripts used during the build process.
- `tests/`: Test suite to ensure extensions are compiled and load correctly.
- `.github/workflows/`: GitHub Actions for automated building, testing, and releasing.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
