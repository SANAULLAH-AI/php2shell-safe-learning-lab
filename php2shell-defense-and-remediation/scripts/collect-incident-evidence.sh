#!/usr/bin/env bash
# Minimal read-only evidence collector. Run only under an approved IR procedure.
# Output can contain sensitive host/process details; store securely and restrict access.
set -u
OUT="${1:-php2shell-evidence-$(date -u +%Y%m%dT%H%M%SZ).txt}"
umask 077
{
  echo "PHP2Shell minimal triage collection"
  date -u +"UTC %Y-%m-%dT%H:%M:%SZ"
  echo "Hostname:"; hostname -f 2>/dev/null || hostname
  echo
  echo "Kernel:"; uname -a
  echo
  echo "PHP CLI:"; (php -v 2>&1 || true)
  echo
  echo "Processes:"; ps -efww 2>&1
  echo
  echo "Network sockets:"; (ss -plantue 2>&1 || netstat -plantue 2>&1 || true)
  echo
  echo "Recent journal matches:"; (journalctl --since "48 hours ago" --no-pager 2>/dev/null |
    grep -Ei 'php|oom|segfault|fatal error|apache|nginx|httpd' | tail -n 500 || true)
  echo
  echo "Recent system authentication events may require separate collection."
} > "$OUT"
chmod 600 "$OUT"
echo "Wrote $OUT"
echo "Protect this file: it may contain sensitive host/process/network metadata."
echo "This is not a forensic image and does not preserve all volatile evidence."
