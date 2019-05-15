FROM docker:18.06-dind

RUN apk update && apk upgrade && \
	apk add --no-cache git bash gcc make musl-dev libffi-dev openssl-dev python-dev py-pip && \
	pip install docker-compose

