# 5. Incident response: assume compromise if evidence supports it

A successful RCE may allow actions under the PHP/web-server service account. Do not assume root access, but do not assume the damage is limited to one website either.

## First 15 minutes

1. Declare an incident and identify the technical owner.
2. If active exploitation is suspected, restrict public access or isolate the host in coordination with operations.
3. Preserve volatile evidence where feasible: process list, network connections, logged-in sessions and container state. Follow your organization's legal/forensic process.
4. Preserve logs and snapshots; avoid immediately deleting suspicious files.
5. Record UTC timestamps, hostnames, runtime versions, deployment IDs and actions taken.
6. Patch from a trusted vendor source as soon as practical, but preserve enough evidence for investigation.

## Evidence to collect

- reverse proxy, CDN, WAF, web-server and PHP-FPM logs;
- system journal / Windows event logs;
- process execution and endpoint detection telemetry;
- DNS and outbound connection logs;
- filesystem changes, web roots, upload directories, temporary directories and scheduled tasks;
- new users, SSH keys, cron jobs, systemd services and startup entries;
- container image IDs, pod events, deployment history and Kubernetes audit logs;
- database, cloud, object-storage and secret-manager audit logs.

The included collector only gathers a small, read-only subset of Linux host information. It is not a forensic imaging tool and should be run under approved incident procedures.

## Indicators worth investigating

- unexpected shell or scripting processes descended from PHP-FPM, Apache, `httpd`, `php-cgi` or a web worker;
- new executable files or PHP files in upload/cache/temp directories;
- recently modified web files outside a planned deployment;
- unexpected outbound DNS/HTTP connections from a web worker;
- new credentials, users, SSH keys, scheduled jobs or services;
- unusual multipart POST bursts followed by 5xx responses or process crashes;
- database access inconsistent with normal application behavior.

These are investigative leads, not definitive indicators. Legitimate image converters, PDF generators, queue workers and deployment tools may also create child processes.

## Credential rotation

If compromise is plausible, rotate secrets that the affected service could access, after containment:
- database credentials;
- cloud credentials and service tokens;
- API keys;
- application signing/encryption secrets where rotation is supported;
- deployment tokens and CI/CD secrets;
- administrator sessions and passwords if exposed.

Do not rotate secrets from a host that may still be compromised unless you have a clean trusted path.

## Recovery

Prefer rebuilding from known-good images/backups and redeploying trusted application code over deleting a single suspicious file. Validate backups before restore. Patch before reconnecting to the internet, restore least privilege, monitor closely, and document lessons learned.
