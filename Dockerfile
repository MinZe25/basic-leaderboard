# FROM alpine:3.13

# ENV PGDATA=/var/lib/postgresql/data

# RUN apk add --no-cache \
#       s6 \
#       su-exec \
#       openssh \
#       openssl \
#       postgresql \
#     mkdir -p /code && \
#     mkdir -p $PGDATA && chmod 0755 $PGDATA && \
#     mkdir -p /run/postgresql && chmod g+s /run/postgresql && \
#     ssh-keygen -A && \
#     rm -f /var/cache/apk/*

# WORKDIR /code

# COPY run.sh /usr/local/bin/run.sh
# COPY s6.d /etc/s6.d

# RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*
# RUN run.sh
FROM node:16-alpine3.11 AS node_base

ENV PGDATA=/var/lib/postgresql/data

RUN apk add --no-cache \
    s6 \
    su-exec \
    openssh \
    openssl \
    postgresql
WORKDIR /code
RUN     mkdir -p /code && \
    mkdir -p $PGDATA && chmod 0755 $PGDATA && \
    mkdir -p /run/postgresql && chmod g+s /run/postgresql

COPY run.sh /usr/local/bin/run.sh
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version
WORKDIR /code

COPY package*.json ./
RUN npm install
RUN npm install -g typescript
RUN npm install -g ts-node
COPY . .
COPY src /code/src
EXPOSE 3000
ENTRYPOINT [ "run.sh" ]
