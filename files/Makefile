PROG_NAME = <name>
VERSION = <version>
GITURL = <git url>
DARWIN-AMD64   = $(PROG_NAME).$(VERSION).darwin-amd64
LINUX-386      = $(PROG_NAME).$(VERSION).linux-386
LINUX-AMD64    = $(PROG_NAME).$(VERSION).linux-amd64
LINUX-ARM64    = $(PROG_NAME).$(VERSION).linux-arm64
LINUX-MIPS64EL = $(PROG_NAME).$(VERSION).linux-mips64el
WIN-386        = $(PROG_NAME).$(VERSION).windows-386.exe
WIN-AMD64      = $(PROG_NAME).$(VERSION).windows-amd64.exe
LDFLAGS="-extldflags -static \
	-X main.Version=$(VERSION) \
	-X main.GitURL=$(GITURL) \
	-X main.Commit=`git rev-parse HEAD` \
	-X main.Branch=`git rev-parse --abbrev-ref HEAD` \
	-X main.BuildTime=`date -u '+%Y-%m-%d_%H:%M:%S'`"

GO=go

all: linux windows darwin

darwin:
	@CGO_ENABLED=0 GOOS=darwin GOARCH=amd64   $(GO) build -ldflags $(LDFLAGS) -o $(DARWIN-AMD64)

linux:
	@CGO_ENABLED=0 GOOS=linux GOARCH=386      $(GO) build -ldflags $(LDFLAGS) -o $(LINUX-386)
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64    $(GO) build -ldflags $(LDFLAGS) -o $(LINUX-AMD64)
	@CGO_ENABLED=0 GOOS=linux GOARCH=arm      $(GO) build -ldflags $(LDFLAGS) -o $(LINUX-ARM64)
	@CGO_ENABLED=0 GOOS=linux GOARCH=mips64le $(GO) build -ldflags $(LDFLAGS) -o $(LINUX-MIPS64EL)

windows:
	@CGO_ENABLED=0 GOOS=windows GOARCH=386    $(GO) build -ldflags $(LDFLAGS) -o $(WIN-386)
	@CGO_ENABLED=0 GOOS=windows GOARCH=amd64  $(GO) build -ldflags $(LDFLAGS) -o $(WIN-AMD64)

up:
	@for f in $(DARWIN-AMD64) $(LINUX-386) $(LINUX-AMD64) $(LINUX-ARM64) $(LINUX-MIPS64EL) $(WIN-386) $(WIN-AMD64); do ./$(DARWIN) -b kodoe -f $$f; done

clean:
	@go clean
	@-rm $(DARWIN-AMD64) $(LINUX-386) $(LINUX-AMD64) $(LINUX-ARM64) $(LINUX-MIPS64EL) $(WIN-386) $(WIN-AMD64) 2> /dev/null || true
