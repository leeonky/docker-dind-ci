FROM docker:18.06-dind

RUN apk update && apk upgrade && \
	apk add --no-cache git bash python pip && \
	pip install docker-compose
