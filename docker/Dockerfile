ARG OPENRESTY_VERSION=1.27.1.2

FROM harbor.peinser.com/dockerhub/openresty/openresty:${OPENRESTY_VERSION}-bookworm

LABEL maintainer="Joeri Hermans <joeri@peinser.com>"

EXPOSE 8000

RUN mkdir -p /var/logs/nginx

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf