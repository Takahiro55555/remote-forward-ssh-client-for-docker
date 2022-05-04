FROM debian:bullseye-slim

RUN apt-get update; \
    apt-get -y install --no-install-recommends \
    autossh; \
    apt-get clean

# Reference: https://dev.classmethod.jp/articles/remote-port-forward-with-soracom-and-autossh/
ENV COMPRESSION=no
ENV EXIT_ON_FAILURE=yes
ENV STRICT_HOST_KEY_CHECKING=no
ENV SERVER_ALIVE_INTERVAL=60
ENV SERVER_ALIVE_COUNT_MAX=3
ENV USER_KNOWN_HOSTS_FILE=/dev/null
ENV REMOTE_PROXY_SSH_PORT=22
ENV IDENTITY_FILE_PATH=/root/.ssh/id_rsa
ENV REMOTE_PROXY_LISTEN_PORT=8080
ENV TARGET_HOST=target.example.com
ENV TARGET_PORT=80
ENV REMOTE_PROXY_SSH_USER=proxy
ENV REMOTE_PROXY_HOST=proxy.example.com

# NOTE: 環境変数を反映するために、Bashを呼び出している
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/autossh \
    -o Compression=${COMPRESSION} \
    -o ExitOnForwardFailure=${EXIT_ON_FAILURE} \
    -o StrictHostKeyChecking=${STRICT_HOST_KEY_CHECKING} \
    -o ServerAliveInterval=${SERVER_ALIVE_INTERVAL} \
    -o ServerAliveCountMax=${SERVER_ALIVE_COUNT_MAX} \
    -o UserKnownHostsFile=${USER_KNOWN_HOSTS_FILE} \
    -p ${REMOTE_PROXY_SSH_PORT} \
    -i ${IDENTITY_FILE_PATH} \
    -NT \
    -R ${REMOTE_PROXY_LISTEN_PORT}:${TARGET_HOST}:${TARGET_PORT} ${REMOTE_PROXY_SSH_USER}@${REMOTE_PROXY_HOST}"]
