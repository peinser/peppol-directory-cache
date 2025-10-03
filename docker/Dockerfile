ARG OPENRESTY_VERSION=1.27.1.2

FROM harbor.peinser.com/dockerhub/openresty/openresty:${OPENRESTY_VERSION}-bookworm

LABEL maintainer="Joeri Hermans <joeri@peinser.com>"

EXPOSE 8000

RUN mkdir -p /var/logs/nginx

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Create a non-root user and group with uid 1001 and gid 1001
RUN groupadd -g 1001 peppol && \
    useradd -u 1001 -g peppol -s /bin/false -M peppol && \
    # Create required directories with correct ownership
    mkdir -p /var/cache/nginx /var/logs/nginx && \
    chown -R peppol:peppol /var/cache/nginx /var/logs/nginx && \
    chmod -R 750 /var/cache/nginx /var/logs/nginx && \
    # Adjust OpenResty/Nginx directories for rootless access
    chown -R peppol:peppol /usr/local/openresty && \
    chmod -R 750 /usr/local/openresty

USER peppol

COPY --chown=peppol:peppol --chmod=640 ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf