.RECIPEPREFIX := >
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo 0.0.0)
PLUGIN := net-forward
DIST_DIR := dist
BUILD_DIR := $(DIST_DIR)/$(VERSION)
TARBALL := $(PLUGIN)_$(VERSION).tar.gz
MANIFEST_OWNER ?= REPO_OWNER

.PHONY: all clean build package manifest

all: package manifest

build:
>mkdir -p $(BUILD_DIR)
>cp $(PLUGIN) $(BUILD_DIR)/
>cp LICENSE $(BUILD_DIR)/

package: build
>tar -czf $(TARBALL) -C $(BUILD_DIR) $(PLUGIN) LICENSE
>sha256sum $(TARBALL) > $(TARBALL).sha256

manifest: package
>mkdir -p $(DIST_DIR)
>./scripts/update-manifest.sh $(VERSION) $(shell cut -d' ' -f1 $(TARBALL).sha256) $(MANIFEST_OWNER)

clean:
>rm -rf $(DIST_DIR) $(PLUGIN)_*.tar.gz $(PLUGIN)_*.tar.gz.sha256
