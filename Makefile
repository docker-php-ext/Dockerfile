# Makefile to build PHP extensions for different versions

# Usage:
#   make build extension=bcmath php_version=8.1
#   make build extension=pdo_mysql php_version=8.2

.PHONY: build

build:
	@if [ -z "$(extension)" ]; then echo "Error: extension is not set. Use: make build extension=<extension> version=<version>"; exit 1; fi
	@if [ -z "$(php_version)" ]; then echo "Error: version is not set. Use: make build extension=<extension> version=<version>"; exit 1; fi
	@if [ ! -f extensions/$(extension)/$(php_version)/Dockerfile.alpine ]; then echo "Error: Dockerfile extensions/$(extension)/$(php_version)/Dockerfile.alpine not found."; exit 1; fi
	docker build \
		-t dockerphpext/$(extension)-$(php_version) \
		-f extensions/$(extension)/$(php_version)/Dockerfile.alpine \
		.
	@EXT_VERSION=$$(docker run --rm dockerphpext/$(extension)-$(php_version) php --ri $(extension) | grep '$(extension) version =>' | awk '{print $$NF}'); \
	if [ -n "$$EXT_VERSION" ]; then \
		echo "Detected $(extension) version: $$EXT_VERSION"; \
		docker tag dockerphpext/$(extension)-$(php_version) dockerphpext/$(extension):$$EXT_VERSION-php$(php_version)-alpine; \
		echo "Tagged: dockerphpext/$(extension):php$(php_version)-alpine-$$EXT_VERSION"; \
	fi

act-build:
	act -P ubuntu-latest=catthehacker/ubuntu:act-22.04 --workflows .github/workflows/build.yml --container-daemon-socket /var/run/docker.sock --matrix version:$(version) --matrix extension:$(extension); \

run-single-test:
	set -e; \
	echo "PHP_VERSION=$$php_version"; \
	echo "###############################################"; \
	echo "###############################################"; \
	echo "### Testing $(extension) PHP $$php_version"; \
	echo "###"; \
	docker build \
		-f tests/Dockerfile \
		--build-arg DISTRO=alpine \
		--build-arg PHP_VERSION=$$php_version \
		--build-arg EXTENSION=$(extension) \
		-t test-$(extension)-$$php_version \
		tests; \
	docker run --rm \
		test-$(extension)-$$php_version \
		php /opt/php/tests/test.php $(extension); \
	if docker run --rm test-$(extension)-$$php_version php -v 2>&1 | grep -Eqi 'Unable|Warning'; then \
		echo "❌ PHP extension load failed"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "✅ Test passed"; \
	echo ""; \

run-test:
	@if [ "$(extension)" != "*" ]; then \
		[ -d "extensions/$(extension)" ] || { echo "Extension not found"; exit 1; }; \
	fi; \
	set -euo pipefail; \
	for path in extensions/$(extension)/*/; do \
		[ -d "$$path" ] || continue; \
		php_version=$$(basename "$$path"); \
		$(MAKE) run-single-test extension=$(extension) php_version=$$php_version; \
	done
