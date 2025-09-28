ARG CADDY_VERSION=2.10.2
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN apk add --no-cache gcc musl-dev

RUN xcaddy build ${CADDY_VERSION} \
  --with github.com/greenpau/caddy-security@v1.1.31
  # --with github.com/mholt/caddy-l4@master

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY ./conf/Caddyfile /etc/caddy/Caddyfile

RUN caddy validate --config /etc/caddy/Caddyfile