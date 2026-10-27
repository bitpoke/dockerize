.PHONY : all dockerize clean fmt dist-clean dist release

TAG:=`git describe --abbrev=5 --dirty --tags`
LDFLAGS:=-X main.buildVersion=$(TAG)

all: dockerize

dockerize:
	echo "Building dockerize"
	go install -ldflags "$(LDFLAGS)"

dist-clean:
	rm -rf dist
	rm -f dockerize-*.tar.gz

dist: dist-clean
	mkdir -p dist/linux/amd64 && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -tags netgo -ldflags "$(LDFLAGS)" -o dist/linux/amd64/dockerize
	mkdir -p dist/linux/arm64 && CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -tags netgo -ldflags "$(LDFLAGS)" -o dist/linux/arm64/dockerize
	mkdir -p dist/darwin/amd64 && CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -tags netgo -ldflags "$(LDFLAGS)" -o dist/darwin/amd64/dockerize
	mkdir -p dist/darwin/arm64 && CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -tags netgo -ldflags "$(LDFLAGS)" -o dist/darwin/arm64/dockerize

release: dist
	tar -cvzf dockerize-linux-amd64-$(TAG).tar.gz -C dist/linux/amd64 dockerize
	tar -cvzf dockerize-linux-arm64-$(TAG).tar.gz -C dist/linux/arm64 dockerize
	tar -cvzf dockerize-darwin-amd64-$(TAG).tar.gz -C dist/darwin/amd64 dockerize
	tar -cvzf dockerize-darwin-arm64-$(TAG).tar.gz -C dist/darwin/arm64 dockerize
