FROM --platform=$BUILDPLATFORM balenalib/raspberry-pi-debian:latest

RUN apt-get update && \
    apt-get install -qqy --no-install-recommends wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV ASCEND_SERVICES=/ascend/services
ENV ASCEND_HEALTHCHECKS=/ascend/healthchecks
ENV ASCEND_SOCKET=/var/run/ascend.socket
ENV ASCEND_LOGS=/var/log/ascend
ENV ASCEND_INIT="/init.sh"

RUN printf '#!/bin/sh\n\
	if [ -z "$GITHUB_TOKEN" ]; then\n\
		wget "$@" \n\
	else\n\
		wget --header "Authorization: token $GITHUB_TOKEN" "$@" \n\
	fi\n' > /usr/local/bin/auth_wget && chmod +x /usr/local/bin/auth_wget

RUN auth_wget https://raw.githubusercontent.com/alis-is/ascend/main/tools/setup/standalone-linux.sh -O /tmp/setup-ascend.sh && sh /tmp/setup-ascend.sh --prerelease

RUN mkdir -p /ascend/services /ascend/healthchecks /var/run/ascend /var/log/ascend
ADD services /ascend/services

ADD service.sh /service.sh
ADD init.sh /init.sh
RUN chmod a+x /init.sh /service.sh

ENTRYPOINT [ "ascend" ]