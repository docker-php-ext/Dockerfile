# Makefile to build PHP extensions for different versions

# Usage:
#   make build extension=bcmath php_version=8.1
#   make build extension=pdo_mysql php_version=8.2

.PHONY: build

build:
	@if [ -z "$(extension)" ]; then echo "Error: extension is not set. Use: make build extension=<extension> php_version=<version>"; exit 1; fi
	@if [ -z "$(php_version)" ]; then echo "Error: php_version is not set. Use: make build extension=<extension> php_version=<version>"; exit 1; fi
	@if [ ! -f extensions/$(extension)/$(php_version)/Dockerfile.alpine ]; then echo "Error: Dockerfile extensions/$(extension)/$(php_version)/Dockerfile.alpine not found."; exit 1; fi
	@BUILDER_IMAGE=dockerphpext-local/builder-$(extension)-$(php_version); \
	TEST_IMAGE=test-dockerphpext-local/$(extension)-$(php_version); \
	FINAL_IMAGE=dockerphpext-local/$(extension)-$(php_version); \
	docker build \
		-t $$BUILDER_IMAGE \
		-f extensions/$(extension)/$(php_version)/Dockerfile.alpine \
		. && \
	docker build \
		-t $$TEST_IMAGE \
		--target test \
		--build-arg PHP_VERSION=$(php_version) \
		--build-arg DISTRO=alpine \
		--build-arg BUILDER_IMAGE=$$BUILDER_IMAGE \
		-f extensions/Dockerfile \
		. && \
	docker build \
		-t $$FINAL_IMAGE \
		--build-arg PHP_VERSION=$(php_version) \
		--build-arg DISTRO=alpine \
		--build-arg BUILDER_IMAGE=$$BUILDER_IMAGE \
		-f extensions/Dockerfile \
		.

run-single-test: build
	@set -e; \
	TEST_IMAGE=test-dockerphpext-local/$(extension)-$(php_version); \
	echo "###############################################"; \
	echo "### Testing $(extension) PHP $(php_version)"; \
	echo "###"; \
	docker run --rm \
		-v $$(pwd)/tests/test.php:/opt/php/tests/test.php \
		$$TEST_IMAGE \
		php /opt/php/tests/test.php $(extension); \
	if docker run --rm $$TEST_IMAGE php -m 2>&1 | grep -Eqi 'Unable|Warning'; then \
		echo "❌ PHP extension load failed"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "✅ Test passed for $(extension) PHP $(php_version)"; \
	echo ""
