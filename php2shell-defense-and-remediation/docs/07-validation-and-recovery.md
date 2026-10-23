# 7. Validation and recovery checklist

Use this checklist after patching.

## Runtime validation

- [ ] All PHP installations have been inventoried, including containers and panel-managed versions.
- [ ] Vendor advisory or package changelog confirms the fix/backport.
- [ ] Web-serving runtime verified (not just CLI PHP).
- [ ] PHP-FPM pools / Apache / CGI / FrankenPHP / LiteSpeed workers restarted as applicable.
- [ ] Old containers, replicas and images are retired.
- [ ] No unexpected service remains bound to the internet.

## Application validation

- [ ] Login, key workflows, uploads and scheduled jobs work.
- [ ] Upload size/type constraints match application requirements.
- [ ] Error logs do not show new fatal errors or configuration warnings.
- [ ] WAF/proxy limits do not break legitimate requests.
- [ ] Monitoring alerts are enabled for crashes, child processes and outbound traffic.

## Security validation

- [ ] Review suspicious requests and worker crashes for the exposure window.
- [ ] Review unexpected processes, files, accounts, scheduled tasks and outbound connections.
- [ ] Confirm backups and deployment artifacts are trusted.
- [ ] Rotate secrets if compromise is suspected.
- [ ] Incident owner records findings and residual risk.

## Validation command

```bash
sudo ./scripts/validate-remediation.sh
```

This script reports local version and configuration hints. It cannot verify vendor backports or prove that the web-facing process uses the same PHP binary. Pair output with package metadata and provider confirmation.
