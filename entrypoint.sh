#!/bin/sh

caddy start --config /usr/local/caddy/Caddyfile --adapter=caddyfile
aria2c \
	"--conf-path=${CONF_DIR}/aria2.conf" \
	"--input-file=${ARIA_SESSION_FILE}" \
	"--save-session=${ARIA_SESSION_FILE}" \
	"--rpc-secret=${RPC_SECRET}"
