# 4. Temporary mitigations when patching is delayed

**Patching or moving to a vendor-verified fixed build is the only complete remediation.** The following are emergency risk-reduction options drawn from vendor guidance; they can affect uploads or availability. Test first and get platform-specific advice.

## CVE-2026-109619-related mitigation

Some vendor guidance recommends disabling PHP session upload-progress tracking at a configuration layer that applies *before request parsing*:

```ini
session.upload_progress.enabled = Off
```

Important:
- Apply through the active `php.ini`, PHP-FPM pool configuration, or server-level configuration supported by your runtime.
- Do not rely on `ini_set()` in application code; the affected processing may occur before the application script.
- Do not assume `.user.ini` applies early enough.
- Restart every relevant worker after changing the configuration.
- This only blocks a described path; it is not a complete fix.

Some guidance also describes disabling fatal-error backtraces on PHP 8.5 where supported:

```ini
fatal_error_backtraces = Off
```

Confirm the directive is valid for the exact PHP version and vendor build. This blocks only a particular path and is not a replacement for patching.

## CVE-2026-109618-related mitigation

Vendor guidance includes controls around request size and upload limits. These settings must be selected based on real application requirements and the exact vendor advisory.

Example baseline for a site that does **not** need uploads:

```ini
post_max_size = 8M
upload_max_filesize = 4M
max_file_uploads = 5
```

For applications that need uploads, choose values based on legitimate file sizes and enforce limits at the reverse proxy/web server too. Request body limits do not necessarily constrain all multipart parsing costs, and requests may omit or misstate `Content-Length`.

**Memory limit warning:** do not copy `memory_limit=-1` or any other generic setting blindly. One vendor advisory describes removing a controllable PHP memory-limit failure for a specific path, but disabling PHP's memory limit can create denial-of-service risk and is inappropriate for many environments. Follow the current official PHP/vendor guidance for your exact runtime and use OS/container memory controls. Get a security engineer to review this trade-off.

## Isolation and WAF controls

If you cannot patch promptly:
- consider taking the exposed service offline or restricting access to trusted source networks;
- put a strict reverse-proxy request-size policy in place;
- disable unneeded upload functionality temporarily;
- isolate PHP workers from sensitive networks and host files;
- reduce filesystem write permissions and outbound network access;
- apply vendor WAF rules if available, while recognizing that WAF rules are incomplete.

Do not rely on a single regex or user-agent block. Attack requests can be varied and the bug is in the runtime.

## Restart and verification

Changes to PHP configuration may not apply to existing workers until they are restarted. Verify effective configuration using the actual service's configuration and vendor tools. Avoid exposing `phpinfo()` publicly.
