FROM docker:18.06-dind

RUN docker pull mysql:5.7 && \
	docker pull jamesdbloom/mockserver:mockserver-5.4.1 && \
	docker pull redis:5.0.4 && \
	docker pull jwilder/nginx-proxy:alpine && \
	docker pull busybox && \
	apk update && apk upgrade && \
	apk add --no-cache git
