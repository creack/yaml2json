NAME            = yaml2json

SRCS            = $(shell find . -name '*.go')

APP_DIR         = github.com/creack/yaml2json
DOCKER_IMG      = creack/$(NAME)

all             : install
install         :
		@hash go || (echo "go binary not found" >&2; exit 1)
		go install -ldflags '-d -w' -a

build           : .build
.build          : $(SRCS) Dockerfile
		docker build --build-arg APP_DIR=$(APP_DIR) -t $(DOCKER_IMG):dev .
		@touch $@

.DELETE_ON_ERROR:
.assets.tar.gz  : build
		docker run --rm '$(DOCKER_IMG):dev' sh -c "cd \$$GOPATH/bin && tar -czf- yaml2json" > $@

release         : .assets.tar.gz
		docker build -t '$(DOCKER_IMG):latest' -f Dockerfile.release .

push            : release
		docker push '$(DOCKER_IMG):latest'

test            : .build
		docker run --rm -it '$(DOCKER_IMG):dev' gometalinter --deadline=2m .

clean           :
		@rm -f .build .assets.tar.gz

.PHONY          : build clean all install push test release
