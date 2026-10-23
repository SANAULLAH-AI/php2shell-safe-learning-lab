# Safe lab plan for a real technical learning path

This directory intentionally does not ship a vulnerable PHP image or exploit. For hands-on study, create an isolated disposable VM or private lab network with no route to production systems.

## Learning stages

1. **HTTP fundamentals:** inspect a normal multipart request to a local application using browser devtools or Burp Suite Community. Do not send exploit strings.
2. **PHP runtime inventory:** learn the difference between CLI PHP, PHP-FPM, Apache `mod_php`, and containerized PHP.
3. **Memory safety:** read about initialization, cleanup, allocator behavior, use-after-free, and out-of-memory handling in native code.
4. **Patch comparison:** compare the vendor's fixed source/package notes with the affected release. Focus on the corrected lifetime/cleanup logic rather than weaponizing the bug.
5. **Detection:** run `detections/hunt_web_logs.py` on synthetic or sanitized logs, then tune against normal traffic.
6. **Remediation rehearsal:** deploy a patched runtime in a disposable staging environment, restart workers, validate the application and write a change record.
7. **Incident tabletop:** assume a web worker spawned an unexpected process. Practice evidence preservation, containment, secret rotation, and clean rebuild.

## Rules for a lab

- Use only systems you own and isolate from the public internet.
- Never test against a random website or a hosting provider without written authorization.
- Do not store real customer/patient data or secrets in the lab.
- Do not publish weaponized payloads or remote-shell instructions.
- Destroy the VM after the exercise and retain only sanitized logs and notes.
