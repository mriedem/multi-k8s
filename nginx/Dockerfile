FROM nginx
# Overwrite default.conf in the filesystem image in the container.
# Note that for prod we could have a separate default.conf
# that does not have the websocket proxy route.
COPY ./default.conf /etc/nginx/conf.d/default.conf