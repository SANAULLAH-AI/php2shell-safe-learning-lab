#!/usr/bin/env bash
# Read-only display of PHP configuration hints. Does not change settings.
set -u
if ! command -v php >/dev/null 2>&1; then
  echo "PHP CLI not found. Inspect the actual serving runtime via your host/panel."
  exit 2
fi
echo "PHP binary: $(command -v php)"
php -v | head -n 2
echo
php --ini
echo
php -i 2>/dev/null | grep -E \
'^(Server API|Loaded Configuration File|Scan this dir for additional .ini files|session.upload_progress.enabled|post_max_size|upload_max_filesize|memory_limit|fatal_error_backtraces|expose_php|display_errors|log_errors) =>' || true
echo
echo "This only reports CLI configuration and may not match FPM/Apache/CGI."
