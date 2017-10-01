#
# Community / CPython 3
#
CROSSBAR_VERSION='17.9.2'
BUILD_DATE=`date -u +"%Y-%m-%d"`

default:
	@echo ""
	@echo "Targets:"
	@echo ""
	@echo "  params                 Print build parameter"
	@echo "  build                  Build images"
	@echo "  version                Print version of images"
	@echo "  test                   Test images"
	@echo "  publish                Publish images"
	@echo ""


params:
	@echo "Crossbar version: ${CROSSBAR_VERSION}"
	@echo "Build date: ${BUILD_DATE}"

build:
	# enforce auto-generating a new key when using the images
	rm -f node/.crossbar/key.*
	time docker build --no-cache \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg CROSSBAR_VERSION=${CROSSBAR_VERSION} \
		-t p1c2u/openshift-crossbar:latest \
		-t p1c2u/openshift-crossbar:cpy3 \
		-t p1c2u/openshift-crossbar:cpy3-${CROSSBAR_VERSION} \
		.

version:
	docker run \
		--rm --entrypoint=/usr/local/bin/crossbar -it \
		p1c2u/openshift-crossbar:cpy3 version

test:
	docker run \
		--rm -it -p 8080:8080 --name crossbar \
		p1c2u/openshift-crossbar:cpy3

publish:
	docker push p1c2u/openshift-crossbar:latest
	docker push p1c2u/openshift-crossbar:cpy3
	docker push p1c2u/openshift-crossbar:cpy3-${CROSSBAR_VERSION}

list:
	docker images p1c2u/openshift-crossbar*
