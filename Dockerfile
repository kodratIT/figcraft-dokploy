# Unduh dan verifikasi release web FigCraft
FROM alpine:3.21 AS download

ARG FIGCRAFT_VERSION=0.16.0

RUN apk add --no-cache curl unzip

WORKDIR /tmp/figcraft

RUN set -eux; \
    BASE_URL="https://github.com/storytold/figcraft/releases/download/v${FIGCRAFT_VERSION}"; \
    FILE="figcraft-web-${FIGCRAFT_VERSION}.zip"; \
    curl -fsSLO "${BASE_URL}/${FILE}"; \
    curl -fsSLO "${BASE_URL}/SHA256SUMS.txt"; \
    grep "  ${FILE}$" SHA256SUMS.txt | sha256sum -c -; \
    unzip -q "${FILE}" -d /tmp/site

# Sajikan editor dengan Nginx
FROM nginx:alpine

ARG FIGCRAFT_VERSION=0.16.0

COPY --from=download /tmp/site/figcraft-web-${FIGCRAFT_VERSION}/ /usr/share/nginx/html/

EXPOSE 80
