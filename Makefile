build:
	swift build

test:
	swift test

install:
	swift build -c release -Xswiftc -static-stdlib
	cp -f .build/release/xccovstats /usr/local/bin/xccovstats
