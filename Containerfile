ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

# COPY system_files /
COPY systemd/system /lib/systemd/system
COPY build.sh /tmp/build.sh 

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    rm -rf /tmp/* /var/* && \
    mkdir -p /tmp /var/tmp && \
    chmod -R 1777 /tmp /var/tmp

