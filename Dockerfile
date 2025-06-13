# Use a lightweight Alpine Linux base image
FROM alpine:3.19

# Install necessary packages:
# - curl + unzip to fetch Consul
# - nginx for reverse‐proxy
# - bash + libc6-compat for scripting support
RUN apk add --no-cache curl unzip nginx bash libc6-compat \
    && curl -Lo consul.zip https://releases.hashicorp.com/consul/1.18.1/consul_1.18.1_linux_amd64.zip \
    && unzip consul.zip \
    && mv consul /usr/local/bin/consul \
    && rm consul.zip

# Overwrite the main nginx.conf with our own full config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 8080 (used by Clever Cloud)
EXPOSE 8080

# Start Consul (dev mode, HTTP on 8500) and Nginx (HTTP on 8080)
CMD sh -c "consul agent -dev -client=0.0.0.0 & nginx -g 'daemon off;'"
