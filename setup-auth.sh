#!/bin/sh
set -eu

if [ -z "${FIGCRAFT_AUTH_USER:-}" ] || [ -z "${FIGCRAFT_AUTH_PASSWORD:-}" ]; then
    echo 'FIGCRAFT_AUTH_USER and FIGCRAFT_AUTH_PASSWORD must be set' >&2
    exit 1
fi

case "$FIGCRAFT_AUTH_USER" in
    *[!a-zA-Z0-9_.@+-]*) echo 'FIGCRAFT_AUTH_USER may only contain letters, numbers, _, ., @, + and -' >&2; exit 1 ;;
esac

umask 077
printf '%s\n' "$FIGCRAFT_AUTH_PASSWORD" | htpasswd -i -B -c /etc/nginx/figcraft.htpasswd "$FIGCRAFT_AUTH_USER" >/dev/null
chmod 644 /etc/nginx/figcraft.htpasswd
