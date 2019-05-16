FROM docker:18.06

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN set -eux; \
	apk update && apk upgrade && apk add --no-cache \
		btrfs-progs \
		e2fsprogs \
		e2fsprogs-extra \
		iptables \
		xfsprogs \
		xz \
# pigz: https://github.com/moby/moby/pull/35697 (faster gzip implementation)
		pigz \
		git bash gcc make musl-dev libffi-dev openssl-dev python-dev py-pip && \
	pip install docker-compose \
	; \
# only install zfs if it's available for the current architecture
# https://git.alpinelinux.org/cgit/aports/tree/main/zfs/APKBUILD?h=3.6-stable#n9 ("all !armhf !ppc64le" as of 2017-11-01)
# "apk info XYZ" exits with a zero exit code but no output when the package exists but not for this arch
	if zfs="$(apk info --no-cache --quiet zfs)" && [ -n "$zfs" ]; then \
		apk add --no-cache zfs; \
	fi

# TODO aufs-tools

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
	&& addgroup -S dockremap \
	&& adduser -S -G dockremap dockremap \
	&& echo 'dockremap:165536:65536' >> /etc/subuid \
	&& echo 'dockremap:165536:65536' >> /etc/subgid

# https://github.com/docker/docker/tree/master/hack/dind
ENV DIND_COMMIT 37498f009d8bf25fbb6199e8ccd34bed84f2874b

RUN set -eux; \
	wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind"; \
	chmod +x /usr/local/bin/dind

COPY dockerd-entrypoint.sh /usr/local/bin/

EXPOSE 2375

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []

