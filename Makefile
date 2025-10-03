OPENRESTY = openresty
CONFIG = /workspace/nginx.conf

run:
	$(OPENRESTY) -c $(CONFIG) -g "daemon off;"