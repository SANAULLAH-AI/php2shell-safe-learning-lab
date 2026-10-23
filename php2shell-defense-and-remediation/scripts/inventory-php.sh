#!/usr/bin/env bash
# Read-only PHP runtime inventory helper for hosts you administer.
set -u
echo "== Host =="
hostname -f 2>/dev/null || hostname
date -u +"UTC %Y-%m-%dT%H:%M:%SZ"
echo
echo "== CLI PHP =="
if command -v php >/dev/null 2>&1; then
  command -v php
  php -v 2>&1 | head -n 3
  php --ini 2>&1
  php -i 2>/dev/null | grep -E '^(Server API|Loaded Configuration File|Scan this dir for additional .ini files|session.upload_progress.enabled|post_max_size|upload_max_filesize|memory_limit|fatal_error_backtraces) =>' || true
else
  echo "php command not found in PATH"
fi
echo
echo "== Common services =="
if command -v systemctl >/dev/null 2>&1; then
  systemctl list-units --type=service --all --no-pager 2>/dev/null |
    grep -Ei 'php.*fpm|apache2|httpd|nginx|lsws|litespeed|frankenphp' || true
fi
echo
echo "== PHP processes =="
ps -eo pid,ppid,user,args 2>/dev/null | grep -E '[p]hp-fpm|[p]hp-cgi|[h]ttpd|[a]pache2|[f]rankenphp|[l]sphp' || true
echo
echo "== Containers (if available) =="
if command -v docker >/dev/null 2>&1; then
  docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' 2>/dev/null || true
fi
if command -v podman >/dev/null 2>&1; then
  podman ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' 2>/dev/null || true
fi
echo
echo "NOTE: CLI PHP can differ from the PHP runtime serving a website."
echo "Verify packages, FPM pools, panel settings, containers and vendor backports separately."
