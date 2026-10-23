#!/usr/bin/env bash
# Read-only validation helper; advisory-aware human review is still required.
set -u
echo "== CLI version =="
if command -v php >/dev/null 2>&1; then
  php -v | head -n 2
  echo
  echo "== Package ownership/version hints =="
  PHP_BIN="$(command -v php)"
  if command -v dpkg-query >/dev/null 2>&1; then
    dpkg-query -S "$PHP_BIN" 2>/dev/null || true
    dpkg-query -W -f='${Package} ${Version}\n' 'php*' 2>/dev/null | head -n 80 || true
  elif command -v rpm >/dev/null 2>&1; then
    rpm -qf "$PHP_BIN" 2>/dev/null || true
    rpm -qa | grep -E '^php' | sort || true
  fi
else
  echo "PHP CLI not found"
fi
echo
echo "== Worker process hints =="
ps -eo pid,ppid,user,args 2>/dev/null | grep -E '[p]hp-fpm|[p]hp-cgi|[h]ttpd|[a]pache2|[f]rankenphp|[l]sphp' || true
echo
echo "== Recent service logs (best effort) =="
if command -v journalctl >/dev/null 2>&1; then
  journalctl --since "24 hours ago" --no-pager 2>/dev/null |
    grep -Ei 'php|segfault|out of memory|oom|fatal error' | tail -n 100 || true
fi
echo
echo "MANUAL REQUIRED: confirm vendor backport, web-serving runtime, worker restart, and incident review."
