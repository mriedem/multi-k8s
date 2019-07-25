# Build phase; "as builder" denotes the phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
# No volumes since we don't need
# an external hook to change code
# during dev/test.
COPY ./ ./
# Creates the build folder in the WORKDIR
# so /app/build
RUN npm run build

# Run phase
FROM nginx
# Expose port 3000 for nginx router to do port mapping
EXPOSE 3000
# Overwrite default.conf in the filesystem image in the container.
# Note that for prod we could have a separate default.conf
# that does not have the websocket proxy route.
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
# Don't need to manually start nginx since the
# default behavior in the nginx image container
# is to start nginx