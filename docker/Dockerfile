FROM ubuntu:18.04

COPY run.sh /
RUN apt-get update && apt-get install -y gnupg \
    &&  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    &&  echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list \
    &&  apt-get update \
    &&  apt-get install -y mongodb-org \
    &&  rm -rf /var/lib/apt/lists/* \
    &&  chmod +x /run.sh

EXPOSE "27017"
HEALTHCHECK --interval=5s --timeout=10s --retries=3 \
      CMD mongo --eval "ping: 1" || exit 1

ENTRYPOINT ["/run.sh"]