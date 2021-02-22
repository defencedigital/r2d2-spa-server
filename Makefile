cur-dir:= $(shell basename `pwd`)
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
MICROSERVICE=$(shell basename `git rev-parse --show-toplevel`)
LDFLAGS="-s -w -X main.SVC_RELEASE=1.0.$(shell git rev-list HEAD --count) -X main.SVC_VERSION=$(shell date +%Y%m%d%H%M)@$(shell git rev-parse --verify --short HEAD) -X main.SVC_NAME=$(MICROSERVICE)"
CI_GITHUB_AUTH?="none"
MS_DIR?="cmd/spa-server"


SET_PRIVATE="github.com/defencedigital/*"
build: all

all:
	cd ${MS_DIR}; GOPRIVATE=$(SET_PRIVATE) go build -o ../../service.bin -ldflags=$(LDFLAGS) *.go

build-docker:
	DOCKER_BUILDKIT=1 docker buildx build --no-cache --build-arg ci_github_auth=$(CI_GITHUB_AUTH) --build-arg go_private="$(SET_PRIVATE)" -t $(cur-dir) --ssh default -t $(MICROSERVICE):latest -f build/Dockerfile .

doc:
	go get -u golang.org/x/tools/...
	godoc -http 0.0.0.0:6060

update:
	cd ${MS_DIR}; GOPRIVATE=$(SET_PRIVATE) go get -u ./...

test:
	cd ${MS_DIR}; GOPRIVATE=$(SET_PRIVATE) go test ./...

lint:
	cd ${MS_DIR}; go get -v ./...
	docker run -e LOG_LEVEL=WARN -e VALIDATE_ALL_CODEBASE=true -e VALIDATE_DOCKERFILE=false -e VALIDATE_GO=false -e RUN_LOCAL=true -v ${PWD}/${MS_DIR}:/tmp/lint github/super-linter
	docker run -e LOG_LEVEL=WARN -e VALIDATE_ALL_CODEBASE=true -e VALIDATE_DOCKERFILE=false -e VALIDATE_GO=false -e RUN_LOCAL=true -v ${PWD}/${MS_DIR}:/tmp/lint github/super-linter golangci-lint run ./...

run-dev:
	make; DB_USER=postgres DB_PASSWORD=postgres DB_NAME=postgres ENVIRONMENT=development JWT_ENCRYPTION_KEY=potato ./service.bin