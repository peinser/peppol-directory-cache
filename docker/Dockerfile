ARG OPENRESTY_VERSION=1.25.3.1

FROM openresty/openresty:${OPENRESTY_VERSION}-bookworm

LABEL maintainer="Joeri Hermans <joeri@peinser.com>"

EXPOSE 8000

RUN mkdir -p /var/logs/nginx

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf