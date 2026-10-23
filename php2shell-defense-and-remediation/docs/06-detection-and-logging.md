# 6. Detection and logging

## Log sources

Collect:
- CDN/WAF logs (request ID, method, path, status, size; redact cookies and authorization);
- Nginx/Apache access and error logs;
- PHP-FPM and PHP error logs;
- OS process-creation telemetry;
- endpoint detection and response alerts;
- egress DNS/firewall/proxy logs;
- container runtime and Kubernetes audit logs.

Centralize logs with synchronized clocks. Set retention based on legal and operational requirements.

## What to hunt for

The public advisory describes unauthenticated requests reaching vulnerable PHP request-processing paths. Look for:
- multipart POST requests with unusual size/part count or repeated failures;
- bursts of 5xx responses or PHP worker crashes;
- references to upload-progress fields in suspicious contexts;
- PHP/web workers spawning unexpected shells, interpreters, downloaders or network tools;
- file modifications or outbound connections shortly after suspicious requests.

No single HTTP indicator is conclusive. An attacker may not use a distinctive string, and ordinary upload traffic can be noisy.

## Run the included log triage script

```bash
python3 detections/hunt_web_logs.py /var/log/nginx/access.log
```

It scans a text log for suspicious patterns and prints matching line numbers. It does not modify logs or contact a server. Review matches manually and adapt the patterns to your log format.

## Sigma starter rule

`detections/sigma-web-suspicious-multipart.yml` is a starter idea for a SIEM pipeline, not a production-ready universal rule. Test it against your telemetry, tune false positives, and pair it with endpoint/process detections.
