# Use a lightweight Alpine Linux base image
FROM alpine:3.19

# Install necessary packages:
# - curl and unzip to fetch and unpack Consul binary
# - nginx for reverse‐proxying
# - bash and libc6-compat for shell scripting compatibility
RUN apk add --no-cache curl unzip nginx bash libc6-compat \
    # Download Consul binary
    && curl -Lo consul.zip https://releases.hashicorp.com/consul/1.18.1/consul_1.18.1_linux_amd64.zip \
    # Unzip and move the Consul executable into PATH
    && unzip consul.zip \
    && mv consul /usr/local/bin/consul \
    && rm consul.zip

# Copy our custom Nginx configuration into the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080 (Clever Cloud will bind to this port)
EXPOSE 8080

# Start both Consul (in dev mode, listening on all interfaces) and Nginx
# - Consul listens internally on port 8500
# - Nginx listens on port 8080 and proxies to Consul
CMD sh -c "consul agent -dev -client=0.0.0.0 & nginx -g 'daemon off;'"
