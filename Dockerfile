FROM ubuntu:xenial
MAINTAINER Lars Kellogg-Stedman <lars@oddbit.com>

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ARG PACKAGE_URL=http://downloads-origin.slimdevices.com/nightly/7.9/sc/acac84f6747e927149c62b198403ac47a9df3f58/logitechmediaserver_7.9.2~1533559127_all.deb

RUN apt-get update && \
	apt-get -y install curl wget faad flac lame sox libio-socket-ssl-perl && \
	apt-get clean

RUN curl -Lsf -o /tmp/lms.deb $PACKAGE_URL && \
	dpkg -i /tmp/lms.deb && \
	rm -f /tmp/lms.deb && \
	apt-get clean

# This will be created by the entrypoint script.
RUN userdel squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh
ENTRYPOINT ["/entrypoint.sh"]