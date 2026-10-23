# PHP2Shell: Real-World Assessment, Remediation & Incident-Response Playbook

**Purpose:** a practical repository for administrators, defenders, students, and security teams responding to PHP2Shell (CVE-2026-109618 and CVE-2026-109619).

This is a defensive operations repository—not a toy upload demo. It contains version triage, safe inventory scripts, configuration templates, log-hunting rules, incident-response steps, validation checks, and a deliberately non-exploitative technical explanation.

> **Safety boundary:** this repository does not include a weaponized exploit, memory-corruption payload, remote-shell payload, or code to compromise third-party hosts. It explains the attack mechanism and provides practical tools to identify exposure, patch systems, reduce risk while patching, and investigate possible compromise.

## Important: confirm applicability before changing production

The PHP security team and government advisories report two critical memory-safety issues:
- **CVE-2026-109618** — memory corruption associated with allocation failure / out-of-memory handling during request processing.
- **CVE-2026-109619** — stale request/global state and use-after-free behavior during request cleanup / error handling.

Successful exploitation can permit unauthenticated remote code execution on vulnerable configurations. The risk includes PHP-FPM, Apache `mod_php`, `php-cgi`, FrankenPHP and LiteSpeed. Public reporting describes the risk as especially serious for `mod_php`, where the vulnerable path can be reached before application code runs.

### Fixed upstream versions reported on 2026-10-21

| PHP branch | Fixed upstream release | Action |
|---|---:|---|
| 8.5.x | 8.5.12 | Upgrade to 8.5.12 or later supported patched release |
| 8.4.x | 8.4.27 | Upgrade to 8.4.27 or later supported patched release |
| 8.3.x | 8.3.36 | Upgrade to 8.3.36 or later supported patched release |
| 8.2.x | 8.2.35 | Upgrade to 8.2.35 or later supported patched release |
| 8.1 and older | No ordinary upstream fix for these EOL branches | Upgrade to a supported branch, or obtain and verify a vendor-supported backport |

**Do not blindly install a source tarball over a package-managed production PHP runtime.** Ubuntu, Debian, RHEL, AlmaLinux, Rocky, Amazon Linux, Plesk, cPanel, managed WordPress providers and other vendors may backport fixes or ship PHP in separate packages. Confirm the package's vendor advisory and restart the right workers.

Sources (check for updates):
- Canadian Centre for Cyber Security, AL26-026 (2026-10-21): https://www.cyber.gc.ca/en/alerts-advisories/al26-026-critical-vulnerabilities-impacting-php-cve-2026-109618-cve-2026-109619
- Plesk vendor advisory and temporary mitigations: https://support.plesk.com/hc/en-us/articles/44397729587351-Vulnerability-CVE-2026-109618-and-CVE-2026-109619-PHP2Shell-Remote-code-execution-in-PHP-shipped-with-Plesk
- Red Hat security bulletin: https://access.redhat.com/security/vulnerabilities/RHSB-2026-013
- AWS Threat Intelligence: https://aws.amazon.com/blogs/security/amazon-threat-intelligence-identifies-php2shell-exploitation-prior-to-public-disclosure-in-madpot/

## Repository map

```text
docs/
  01-vulnerability-explained.md
  02-version-and-exposure-matrix.md
  03-remediation-by-platform.md
  04-temporary-mitigations.md
  05-incident-response.md
  06-detection-and-logging.md
  07-validation-and-recovery.md
  08-change-management.md
scripts/
  inventory-php.sh
  check-php-config.sh
  validate-remediation.sh
  collect-incident-evidence.sh
configs/
  nginx/php-upload-limits.conf
  apache/php-upload-limits.conf
  php-fpm/99-php2shell-emergency.ini
  systemd/php-fpm-hardening.example
detections/
  hunt_web_logs.py
  sigma-web-suspicious-multipart.yml
tests/
  test_hunt_web_logs.py
lab/
  README.md
```

## Quick start: triage

1. Read `docs/02-version-and-exposure-matrix.md`.
2. Run `scripts/inventory-php.sh` on each host/container you administer.
3. Compare each runtime with the vendor's advisory and fixed release.
4. Patch using the operating system or hosting vendor's supported update mechanism.
5. Restart all affected PHP workers and web-server processes as directed by the vendor.
6. Run `scripts/validate-remediation.sh` and verify the *web-serving* PHP runtime—not only CLI PHP.
7. Review logs and investigate any signs of compromise using `docs/05-incident-response.md`.

Example:

```bash
chmod +x scripts/*.sh
sudo ./scripts/inventory-php.sh
sudo ./scripts/check-php-config.sh
```

Scripts are read-only unless their names explicitly say otherwise. They do not run exploit payloads or send network requests to external systems.

## Temporary mitigation warning

Temporary controls can reduce exposure but are **not a substitute for a fixed PHP build**. The upstream/vendor recommendations are configuration-sensitive and can conflict with application requirements. Read `docs/04-temporary-mitigations.md` and test in staging before changing production.

## What this repo does not claim

- A version string alone does not prove whether a distro backport is present.
- A log match is not proof of exploitation; normal uploads can create similar events.
- No single WAF rule can reliably block every variant of a memory-corruption exploit.
- The included log detector is triage assistance, not a complete IDS.
- This repository is not an exploit reproduction and does not establish that a system is safe.

## Contribution standards

- Test on disposable systems and staging first.
- Do not commit credentials, patient data, access tokens, private logs, or exploit payloads.
- Redact IPs, cookies, session IDs, authorization headers and personal information before sharing examples.
- Keep links to official vendor advisories current.
