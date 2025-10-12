GOPATH:=$(shell go env GOPATH)

MODULE  := frisboo-bank/customer-write-service

# Project info
BUILD   := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
COMMIT  := $(shell git rev-parse --short HEAD 2>/dev/null || echo 'unknown')
NAME    := $(notdir $(MODULE))
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo v0.0.0)
GOOS    ?= $(shell go env GOOS)
GOARCH  ?= $(shell go env GOARCH)
MARCH   := $(GOOS)-$(GOARCH)

# Local DB info
DB_TARGETS := db-main

# Local DB info
db-main.DB_TYPE := postgres
db-main.DB_CONTAINER_NAME := customer-write-db
db-main.DB_PORT := 5432
db-main.DB_USER := admin
db-main.DB_PASS := admin
db-main.DB_NAME := customer-write

# Build Flags
LDFLAGS := \
	-X '$(MODULE)/internal/version.Name=$(NAME)' \
	-X '$(MODULE)/internal/version.Version=$(VERSION)' \
	-X '$(MODULE)/internal/version.Build=$(BUILD)' \
	-X '$(MODULE)/internal/version.Commit=$(COMMIT)'

# Go Parameters
GO := go
PKG := ./...
BOOTSTRAP := ./cmd/app/
BIN_DIR := bin
COVERAGE := /tmp/$(NAME)-coverage.out

include ../../infra/make/backend/core.mk

#
# DEVELOPMENT
#
## build: build the application
.PHONY: build
build:
	@echo "Building $(NAME) $(VERSION) ($(COMMIT)) for $(MARCH)"
	@mkdir -p $(BIN_DIR)
	go build -ldflags="$(LDFLAGS)" -o $(BIN_DIR)/$(NAME) $(BOOTSTRAP)

## run: run the application
.PHONY: run
run:
	go run $(BOOTSTRAP)

## watch: run the application in watch mode
.PHONY: watch
watch:
	@go run github.com/air-verse/air@latest \
		--root "." \
		--build.cmd "make build" \
	  --build.bin "" \
	  --build.full_bin "go run $(BOOTSTRAP)/main.go" \
	  --build.delay "100" \
		--build.include_dir "../pkg/" \
		--build.exclude_dir "" \
		--build.include_ext "go, tpl, tmpl, html, css, scss, js, ts, sql, jpeg, jpg, gif, png, bmp, svg, webp, ico" \
		--misc.clean_on_exit "true"

#
# PRODUCTION
#
## build/release: build optimized production application
.PHONY: build/release
build/release:
	make build GOOS=$(GOOS) GOARCH=$(GOARCH) -ldflags="$(LDFLAGS) -w -s"

## optimize: compress application binary
.PHONY: optimize
optimize:
	upx -9 -k $(BIN_DIR)/$(NAME) || echo "UPX not installed. Skip..."

## build/docker: build the docker image
.PHONY: build/docker
build/docker:
	docker build -D -t $(NAME):$(VERSION) .

#
# OPERATIONS
#
#.PHONY: init
init:
	@go get -u google.golang.org/protobuf/proto
	@go install github.com/golang/protobuf/protoc-gen-go@latest

## push: push changes to the remote Git repository
.PHONY: push
push: tidy audit lint test no-dirty
	git push

## production/deploy: deploy the application to production
.PHONY: production/deploy
production/deploy: tidy audit lint test no-dirty build/release compress

.PHONY: confirm
confirm:
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
