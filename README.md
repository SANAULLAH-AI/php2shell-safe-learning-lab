# PHP2Shell: Real-World Assessment, Remediation & Incident-Response Playbook

**A defensive security operations toolkit for assessing, mitigating, patching, and investigating PHP2Shell-related exposure.**

[![Security](https://img.shields.io/badge/Focus-Defensive%20Security-blue)](#security-scope-and-safety-boundaries)
[![Purpose](https://img.shields.io/badge/Purpose-Assessment%20%26%20Remediation-green)](#operational-workflow)
[![Environment](https://img.shields.io/badge/Environment-PHP%20%7C%20Web%20Servers-informational)](#supported-environments)
[![Contributions](https://img.shields.io/badge/Contributions-Welcome-brightgreen)](#contributing)

> **Security notice:** This repository is intended for system administrators, security engineers, incident responders, hosting providers, developers, and students conducting authorized defensive work. It does not contain a weaponized exploit, remote-shell payload, or instructions for compromising third-party systems.

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Security Scope and Safety Boundaries](#2-security-scope-and-safety-boundaries)
- [3. Vulnerability Overview](#3-vulnerability-overview)
- [4. Severity and Business Impact](#4-severity-and-business-impact)
- [5. Fixed Versions and Vendor Verification](#5-fixed-versions-and-vendor-verification)
- [6. Supported Environments](#6-supported-environments)
- [7. Repository Structure](#7-repository-structure)
- [8. Operational Workflow](#8-operational-workflow)
- [9. Quick-Start Assessment](#9-quick-start-assessment)
- [10. Exposure Assessment](#10-exposure-assessment)
- [11. Remediation Strategy](#11-remediation-strategy)
- [12. Temporary Risk-Reduction Measures](#12-temporary-risk-reduction-measures)
- [13. Detection and Log Analysis](#13-detection-and-log-analysis)
- [14. Incident Response](#14-incident-response)
- [15. Remediation Validation](#15-remediation-validation)
- [16. Production Change Management](#16-production-change-management)
- [17. Limitations and Known Gaps](#17-limitations-and-known-gaps)
- [18. Security and Privacy Considerations](#18-security-and-privacy-considerations)
- [19. Testing and Lab Guidance](#19-testing-and-lab-guidance)
- [20. Contributing](#20-contributing)
- [21. References and Advisories](#21-references-and-advisories)
- [22. Disclaimer](#22-disclaimer)

---

## 1. Overview

PHP2Shell is the name used in public reporting for a set of critical PHP vulnerabilities identified by the following CVE identifiers:

- **CVE-2026-109618**
- **CVE-2026-109619**

The vulnerabilities described in the advisories involve memory-safety failures in PHP request processing and cleanup. Depending on the affected build, execution path, runtime configuration, and deployment architecture, successful exploitation may allow remote code execution.

This repository provides a practical defensive workflow for answering five important questions:

1. **Are we running an affected PHP runtime?**
2. **Which applications, containers, and web-serving processes could be exposed?**
3. **What remediation does our operating-system or hosting vendor recommend?**
4. **Is there evidence of suspicious activity or possible compromise?**
5. **How can we verify that remediation is complete and document the result?**

The project emphasizes operational usefulness over exploit demonstrations. It combines inventory scripts, configuration-review helpers, log-analysis utilities, response checklists, remediation guidance, and validation procedures.

### Intended audience

| Audience | Primary use |
|---|---|
| System administrators | Inventory PHP installations and coordinate updates |
| Security operations teams | Triage suspicious web activity and preserve evidence |
| Incident responders | Investigate possible compromise and guide recovery |
| Hosting providers | Review customer-facing PHP runtimes and worker processes |
| Developers | Understand deployment risks and coordinate testing |
| Students and researchers | Learn defensive vulnerability-management practices |

### Project objectives

- Establish a repeatable process for exposure assessment.
- Reduce the time between vulnerability disclosure and remediation.
- Avoid unsafe, unverified changes to production runtimes.
- Improve the quality of incident evidence and response documentation.
- Separate confirmed findings from indicators that require further investigation.
- Encourage verification against authoritative vendor advisories.

---

## 2. Security Scope and Safety Boundaries

This is a **defensive operations repository**.

### Included capabilities

- Local PHP version and environment inventory.
- Review of PHP configuration and runtime exposure.
- Vendor-oriented patch planning.
- Example configuration templates for supported web-server architectures.
- Web-log hunting and triage.
- Incident evidence collection.
- Post-remediation validation.
- Change-control and recovery checklists.
- Safe testing in disposable environments.

### Explicitly excluded

This repository does not provide:

- A weaponized remote-code-execution exploit.
- A remote-shell payload or reverse-shell implementation.
- Memory-corruption payloads designed to execute arbitrary code.
- Scripts for compromising unrelated hosts.
- Automated scanning of public IP ranges.
- Persistence, credential theft, or post-exploitation tooling.

### Authorization requirement

Run assessment and evidence-collection tools only on systems you own or are explicitly authorized to administer.

A successful inventory check or clean log scan does not establish that a host is immune to exploitation. Assessment results must be interpreted alongside vendor advisories, package metadata, architecture, configuration, and runtime behavior.

---

## 3. Vulnerability Overview

The CVE identifiers and technical descriptions in this section should be checked against the linked PHP and vendor advisories before being used for incident reporting or formal risk acceptance.

### CVE-2026-109618

Public reporting associates this issue with memory corruption involving allocation-failure or out-of-memory handling during PHP request processing.

Memory-safety defects can produce effects ranging from process crashes to memory corruption. The precise impact depends on the vulnerable code path, runtime build, compiler and allocator behavior, and surrounding execution environment.

### CVE-2026-109619

Public reporting associates this issue with stale request or global state and use-after-free behavior during request cleanup or error handling.

A use-after-free condition occurs when software accesses memory after that memory has been released. Depending on the circumstances, this can lead to instability, memory corruption, or more serious security consequences.

### Why the execution architecture matters

PHP can be deployed through different server integration models, including:

- PHP-FPM behind Nginx or Apache.
- Apache `mod_php`.
- `php-cgi` and FastCGI integrations.
- FrankenPHP.
- LiteSpeed and compatible PHP execution configurations.
- Containerized PHP services.
- Managed hosting platforms with vendor-maintained PHP builds.

Different integrations can expose different request paths and may use different PHP binaries or configuration files.

**Do not assume every PHP deployment is equally exposed.** Confirm the affected versions, applicability conditions, and mitigations in the relevant advisory.

### Important technical distinction

A vulnerability in the PHP runtime is not necessarily an application-level vulnerability.

Updating application code alone may not resolve a defect in the PHP interpreter or its request-processing implementation. Conversely, a PHP version displayed by the command-line interpreter may not match the version used by the web server.

---

## 4. Severity and Business Impact

If the installed runtime and execution path are affected, potential consequences may include:

- Unauthorized execution of code within the privileges of the affected service.
- Exposure of application configuration and secrets accessible to the process.
- Unauthorized access to data available to the application.
- Modification or deletion of application files writable by the service.
- Abuse of the affected host as a platform for further activity.
- Service interruption caused by crashes or instability.
- Compliance, contractual, and reputational consequences.

For applications handling healthcare information, financial data, authentication credentials, or other sensitive information, incident response should also consider applicable privacy, contractual, and regulatory obligations.

### Risk-prioritization factors

Prioritize systems based on the combination of:

1. Confirmed vendor applicability.
2. Public reachability of the affected service.
3. Runtime architecture and configuration.
4. Availability of a vendor-supported fix.
5. Exposure of sensitive information or privileged services.
6. Existing indicators of compromise.
7. The criticality of the hosted application.

A critical severity rating does not automatically prove that a particular installation is exploitable or has been compromised. Those are separate questions requiring separate evidence.

---

## 5. Fixed Versions and Vendor Verification

The following upstream release information was reported on **October 21, 2026** and must be rechecked against the current official PHP and vendor advisories before remediation.

| PHP branch | Reported upstream fixed release | Recommended action |
|---|---:|---|
| PHP 8.5.x | 8.5.12 | Upgrade to an applicable fixed release |
| PHP 8.4.x | 8.4.27 | Upgrade to an applicable fixed release |
| PHP 8.3.x | 8.3.36 | Upgrade to an applicable fixed release |
| PHP 8.2.x | 8.2.35 | Upgrade to a supported fixed build |
| PHP 8.1 and older | No ordinary upstream fix reported for these end-of-life branches | Upgrade to a supported branch or verify a vendor-supported backport |

These version numbers are a starting point for investigation, not a universal compatibility guarantee. Reconfirm them against the official release announcements before deploying an update.

### Why version-string checks are insufficient

Operating-system and hosting vendors may backport security patches without changing the upstream version number to the release listed above. Vendors may also distribute multiple PHP branches and separately maintained packages.

Therefore:

- Check the exact package name and installed package release.
- Review the vendor's security advisory and package changelog.
- Confirm whether the vendor marks the installed build as fixed.
- Check the runtime actually serving application requests.
- Verify that relevant workers and services have loaded the updated build.
- Record the evidence used to conclude that remediation is complete.

### Production safety warning

**Do not overwrite a package-managed production PHP installation with an arbitrary upstream source build.**

Use the supported package manager or hosting-provider update procedure unless your organization explicitly maintains PHP from source.

A manual replacement can break extensions, configuration, service units, permissions, ABI compatibility, and application dependencies.

---

## 6. Supported Environments

The repository contains examples intended to help administrators investigate common PHP deployment models.

| Environment | Assessment focus |
|---|---|
| Linux hosts | Installed PHP packages, binaries, services, and configuration |
| PHP-FPM | Pool configuration, workers, service units, and loaded runtime |
| Nginx | FastCGI routing and the PHP-FPM backend |
| Apache | PHP integration, FastCGI configuration, and active modules |
| Containers | Image tags, image digests, installed packages, and running containers |
| FrankenPHP | Runtime version, deployment image, and vendor-specific guidance |
| LiteSpeed | PHP handler configuration and provider-supported updates |
| Managed hosting | Provider advisories, account-level runtime selection, and provider remediation status |
| Development environments | Dependency compatibility and regression testing |

The scripts and templates are not guaranteed to support every operating system, hosting panel, PHP build, or deployment layout. Review them before execution and adapt them to your environment.

---

## 7. Repository Structure

```text
.
├── README.md
├── docs/
│   ├── 01-vulnerability-explained.md
│   ├── 02-version-and-exposure-matrix.md
│   ├── 03-remediation-by-platform.md
│   ├── 04-temporary-mitigations.md
│   ├── 05-incident-response.md
│   ├── 06-detection-and-logging.md
│   ├── 07-validation-and-recovery.md
│   └── 08-change-management.md
├── scripts/
│   ├── inventory-php.sh
│   ├── check-php-config.sh
│   ├── validate-remediation.sh
│   └── collect-incident-evidence.sh
├── configs/
│   ├── nginx/
│   │   └── php-upload-limits.conf
│   ├── apache/
│   │   └── php-upload-limits.conf
│   ├── php-fpm/
│   │   └── 99-php2shell-emergency.ini
│   └── systemd/
│       └── php-fpm-hardening.example
├── detections/
│   ├── hunt_web_logs.py
│   └── sigma-web-suspicious-multipart.yml
├── tests/
│   └── test_hunt_web_logs.py
└── lab/
    └── README.md
```

### Component responsibilities

**`docs/`**  
Operational guidance for exposure assessment, patching, temporary mitigations, incident response, validation, and change control.

**`scripts/`**  
Local administrative helpers for inventory, configuration review, remediation validation, and evidence collection.

**`configs/`**  
Illustrative configuration templates. These are examples to review and adapt, not universally safe drop-in production configurations.

**`detections/`**  
Log-analysis utilities and a starter Sigma rule for suspicious web-request patterns.

**`tests/`**  
Tests for the included detection utility. Test coverage does not imply comprehensive detection or vulnerability coverage.

**`lab/`**  
Guidance for learning and validating defensive workflows in an isolated environment.

---

## 8. Operational Workflow

Use this workflow when responding to a PHP2Shell advisory or a suspected exposure.

### Phase 1 — Establish scope

Identify:

- Hosts and containers running PHP.
- Public-facing websites and APIs.
- PHP-FPM pools and service units.
- Apache, Nginx, LiteSpeed, and other web-server integrations.
- Managed hosting accounts and control-panel-managed runtimes.
- Production systems that depend on the affected PHP branches.

Maintain an inventory with an owner, environment, runtime source, and business criticality for each asset.

### Phase 2 — Assess applicability

For each asset:

1. Identify the actual PHP runtime used for web requests.
2. Record the upstream version and package release.
3. Determine the execution architecture.
4. Consult the applicable vendor advisory.
5. Check whether a vendor-supported fix or backport is installed.
6. Assign a status: affected, not affected, mitigated pending patch, or unknown.

Do not classify a system as safe merely because the CLI version appears current.

### Phase 3 — Reduce immediate risk

If the installation is affected or its status is unknown:

- Follow the vendor's recommended temporary mitigations.
- Restrict unnecessary public exposure where practical.
- Apply existing WAF or network controls as an additional layer.
- Prioritize the deployment of a supported fix.
- Monitor service health and relevant logs.
- Preserve evidence if suspicious activity is identified.

### Phase 4 — Patch and restart

1. Confirm package and hosting-provider instructions.
2. Test compatibility in staging when feasible.
3. Apply the approved fixed package or image.
4. Restart or reload the required PHP and web-server services.
5. Verify that all active workers use the intended runtime.
6. Confirm that dependent applications remain healthy.

### Phase 5 — Validate

- Re-run inventory checks.
- Confirm vendor package status.
- Check web-serving PHP independently of CLI PHP.
- Inspect service logs for startup errors.
- Run application smoke tests.
- Confirm that temporary mitigations are still appropriate.
- Record the evidence and outstanding risks.

### Phase 6 — Investigate and recover

If compromise is suspected, follow the incident-response procedure in `docs/05-incident-response.md`. Patching alone does not remove persistence, reverse unauthorized changes, or prove that no data was accessed.

---

## 9. Quick-Start Assessment

### Prerequisites

- A supported shell environment.
- Appropriate authorization for the target system.
- Read access to the relevant PHP configuration and logs.
- Administrative privileges only where needed.
- A record of the system's current state before making changes.

The scripts use shell commands and utilities that may differ between Linux distributions. Inspect each script before running it, particularly in production.

### Clone the repository

```bash
git clone https://github.com/SANAULLAH-AI/php2shell-safe-learning-lab.git
cd php2shell-safe-learning-lab
```

### Review the scripts first

```bash
less scripts/inventory-php.sh
less scripts/check-php-config.sh
less scripts/validate-remediation.sh
less scripts/collect-incident-evidence.sh
```

### Run the local inventory

On a compatible Linux host:

```bash
chmod +x scripts/*.sh
./scripts/inventory-php.sh
```

If a script requires elevated access to inspect system services or protected configuration files, review the exact operations before running it with `sudo`.

### Review PHP configuration

```bash
./scripts/check-php-config.sh
```

Interpret the results as configuration-review findings, not as a definitive exploitability test.

### Validate after remediation

```bash
./scripts/validate-remediation.sh
```

Read the output and compare it with the applicable vendor advisory. The script cannot independently certify that every relevant PHP runtime or deployment path is patched.

### Collect incident evidence

Use the evidence-collection script only after reviewing its source and selecting appropriate output locations:

```bash
./scripts/collect-incident-evidence.sh
```

Evidence collection may expose sensitive information. Protect output files, limit access, and follow your organization's retention and handling requirements.

---

## 10. Exposure Assessment

An effective assessment must distinguish between a host's installed PHP packages and the PHP runtime handling external requests.

### Questions to answer

**Runtime**
- Which PHP versions are installed?
- Which binary or image does the application actually use?
- Is the runtime managed by the OS, a hosting panel, a container image, or a custom build?

**Execution architecture**
- Is PHP served through PHP-FPM, `mod_php`, CGI/FastCGI, or another handler?
- Which services and pools are active?
- Are multiple PHP versions installed side by side?

**Package provenance**
- Which vendor supplied the runtime?
- Does the package release contain a backported fix?
- Is the installed build still supported?

**Exposure**
- Is the application reachable from the internet?
- Are unnecessary handlers or services enabled?
- Are there additional network or application-layer controls?

**Evidence**
- Are relevant access and error logs available?
- Are log timestamps consistent?
- Are service restarts and package updates recorded?
- Is there evidence of unexpected child processes or file modifications?

### Suggested assessment record

Record the following for each system:

| Field | Example value |
|---|---|
| Asset identifier | `web-prod-01` |
| Environment | Production |
| Runtime architecture | PHP-FPM behind Nginx |
| PHP version | Observed value |
| Package release | Vendor-specific release |
| Vendor advisory status | Fixed / affected / unknown |
| Public exposure | Internet-facing / internal |
| Temporary mitigation | Applied / not applicable / pending |
| Patch status | Pending / complete / unknown |
| Validation evidence | Command output, package record, service checks |
| Owner | Responsible team |
| Review date | Date of assessment |

Do not put credentials, patient records, session tokens, or other secrets into the assessment record.

---

## 11. Remediation Strategy

### Preferred remediation

The preferred response is to deploy a fixed PHP build supported by the operating-system or hosting vendor.

Recommended sequence:

1. Confirm applicability.
2. Identify the vendor-supported fixed package or image.
3. Review release notes and dependency requirements.
4. Test in staging when practical.
5. Apply the approved update.
6. Restart or recycle the correct services.
7. Verify the active web-serving runtime.
8. Perform application smoke tests.
9. Record the final state.

### Debian and Ubuntu

- Check the installed PHP packages and distribution security notices.
- Use the supported package repositories and upgrade process.
- Check for distribution-specific backports.
- Verify the service and FPM pool names on the actual host.

Do not assume every system uses a service named `php8.4-fpm` or that the default repository contains the same package version as upstream PHP.

### RHEL-family distributions

- Consult the relevant Red Hat or downstream vendor security bulletin.
- Verify the package release and vendor security status.
- Follow the supported update and service-restart procedure.
- Check whether the system uses modular streams, software collections, or vendor-maintained PHP packages.

### Containers

- Identify the exact running image and digest.
- Update the Dockerfile or image definition to a supported fixed base image.
- Rebuild the image using a trusted source.
- Scan and test the resulting image.
- Deploy through the normal release process.
- Confirm that old containers and replicas have been replaced.

Updating a local image tag does not prove that running containers have been recreated.

### Plesk, cPanel, and managed hosting

- Follow the provider's specific advisory.
- Use the hosting panel's supported package and PHP management tools.
- Confirm the PHP handler and version selected by each affected site.
- Ask the provider to confirm remediation if runtime updates are provider-controlled.
- Preserve provider ticket numbers and update evidence.

### End-of-life PHP branches

If a branch no longer receives ordinary upstream security updates:

- Plan migration to a supported branch.
- Evaluate application and extension compatibility.
- Use a vendor-supported backport only when its applicability and maintenance status are documented.
- Record any residual risk and time-bound exception.
- Avoid indefinite reliance on temporary mitigations.

Detailed guidance belongs in `docs/03-remediation-by-platform.md`.

---

## 12. Temporary Risk-Reduction Measures

Temporary mitigations may reduce exposure while a fixed build is being deployed. They do not replace a vendor-supported fix.

Possible measures, depending on the deployment and vendor guidance, include:

- Restricting access to affected services where operationally feasible.
- Disabling unnecessary PHP handlers or unused execution paths.
- Reviewing web-server routing and FastCGI configuration.
- Applying provider-recommended PHP configuration changes.
- Using network controls and WAF protections as additional defense.
- Increasing monitoring for suspicious request patterns and process activity.
- Limiting service-account permissions and unnecessary filesystem write access.

### Configuration template warning

The repository's Nginx, Apache, PHP-FPM, and systemd examples are **illustrative starting points**.

Before applying a template:

1. Read the matching vendor advisory.
2. Compare the example with your existing configuration.
3. Confirm that directives are valid for your installed version.
4. Check whether the directive is inherited or overridden elsewhere.
5. Test configuration syntax.
6. Validate application behavior in staging.
7. Use an approved change window for production.
8. Preserve a rollback plan.

Changing upload limits or PHP settings may disrupt legitimate applications and should not be treated as a universal mitigation for a memory-safety defect.

Detailed guidance: `docs/04-temporary-mitigations.md`.

---

## 13. Detection and Log Analysis

The repository includes a Python log-hunting utility and a starter Sigma rule for identifying suspicious web-request patterns.

These are intended to support triage. They do not prove that an exploit succeeded, and they cannot detect every possible exploitation attempt.

### Log sources to consider

Depending on the architecture and available telemetry, review:

- Nginx access and error logs.
- Apache access and error logs.
- PHP-FPM logs.
- System journal and service logs.
- Container runtime and orchestration events.
- WAF and reverse-proxy events.
- Endpoint detection and response telemetry.
- Authentication and privilege-escalation logs.
- File-integrity monitoring records.
- Application audit logs.

### Example: run the log-hunting utility

Review the script's supported arguments first:

```bash
python3 detections/hunt_web_logs.py --help
```

Then use the syntax documented by the script to analyze an authorized, appropriately sanitized log file.

The command above is a help invocation; it does not perform a vulnerability test.

### What suspicious evidence may warrant investigation?

Depending on the environment, examples include:

- Unexpected PHP worker crashes or restarts.
- Unusual request patterns around the reported exposure period.
- Unexpected child processes spawned by web-service accounts.
- New or modified files in application directories.
- Unexplained changes to PHP configuration or service units.
- Unexpected outbound connections.
- Unusual access to application secrets or sensitive files.
- Unexplained changes to scheduled tasks, accounts, or permissions.

None of these indicators is unique to PHP2Shell. Correlate observations with deployment activity, normal application behavior, timestamps, and other evidence.

### Detection workflow

1. Establish the affected asset and the suspected time window.
2. Preserve original logs before conducting extensive analysis.
3. Run the detector against a working copy where possible.
4. Review matches manually.
5. Correlate with service, process, network, and file-integrity evidence.
6. Document false positives and unresolved findings.
7. Escalate confirmed or credible compromise indicators.

### Sigma rule

The included Sigma file is a starter detection. Adapt its field mappings and log-source assumptions to your SIEM and logging pipeline. Test it against representative benign and suspicious events before relying on it operationally.

Detailed guidance: `docs/06-detection-and-logging.md`.

---

## 14. Incident Response

If you suspect exploitation, treat the incident as a potential compromise until the evidence supports a different conclusion.

### Step 1 — Triage and escalation

- Identify affected hosts, applications, and service owners.
- Determine whether the runtime is confirmed affected or still under investigation.
- Establish the earliest plausible exposure time.
- Notify the incident-response lead and other required stakeholders.
- Preserve relevant alerts, logs, and operational records.

### Step 2 — Containment

Choose containment actions based on business impact and the available evidence:

- Restrict network access where appropriate.
- Isolate a host or workload if compromise is credible.
- Remove an affected instance from service if necessary.
- Preserve a forensic copy or snapshot when feasible and appropriate.
- Coordinate with the hosting provider for provider-managed systems.

Do not destroy a potentially compromised instance before preserving evidence when forensic investigation is required and preservation is feasible.

### Step 3 — Evidence collection

Collect relevant evidence, subject to legal, privacy, and organizational requirements:

- Package versions and security update records.
- PHP and web-server configuration.
- Service status and restart history.
- Relevant access, error, and system logs.
- Process and network observations where available.
- File-integrity or endpoint security alerts.
- Container image identifiers and deployment history.
- Relevant authentication and administrative audit events.

Record collection times, the system involved, the person collecting the evidence, and any transformations made to the evidence.

### Step 4 — Determine scope

Investigate whether suspicious activity extends beyond the initially affected service.

Depending on the evidence, this may include reviewing:

- Other sites sharing the same PHP runtime.
- Other pools running under related service accounts.
- Containers built from the same image.
- Shared application files and deployment artifacts.
- Credentials and secrets accessible to the affected process.
- Adjacent systems with trust relationships to the affected host.

### Step 5 — Eradication and recovery

- Deploy the fixed, supported runtime.
- Remove unauthorized changes and persistence identified during the investigation.
- Rotate credentials and secrets that may have been exposed.
- Rebuild affected systems from trusted images or backups when necessary.
- Restore services only after appropriate validation.
- Monitor for recurrence and unexpected activity.

Patching is necessary for remediation but may be insufficient if an attacker already gained execution.

### Step 6 — Post-incident review

Document:

- Root cause and confirmed findings.
- Affected assets and time window.
- Actions taken and their timestamps.
- Evidence limitations.
- Credentials or secrets rotated.
- Recovery and validation results.
- Remaining risks and accountable owners.
- Improvements to monitoring, patching, and change management.

If sensitive information may have been accessed, consult the organization's privacy, legal, contractual, and regulatory response procedures.

Detailed checklist: `docs/05-incident-response.md`.

---

## 15. Remediation Validation

A remediation is complete only when the updated state has been verified and documented.

### Minimum validation checklist

- [ ] The installed package or runtime matches the applicable vendor fix.
- [ ] Any backport has been verified using vendor documentation.
- [ ] The web-serving runtime has been checked independently of CLI PHP.
- [ ] Relevant PHP workers have restarted or been replaced.
- [ ] Service startup and error logs have been reviewed.
- [ ] Application smoke tests have passed.
- [ ] Monitoring and log collection remain operational.
- [ ] Temporary mitigations have been reviewed for continued necessity.
- [ ] Any suspicious activity has been investigated separately.
- [ ] Evidence and approval records have been retained.
- [ ] Remaining risks have been assigned to an owner.

### What validation does not prove

A successful script run does not prove:

- That every PHP installation on the host has been assessed.
- That a hidden or provider-managed runtime is patched.
- That no exploit attempt occurred.
- That no exploitation succeeded before patching.
- That all persistence or unauthorized changes have been removed.
- That the application has no unrelated vulnerabilities.

Use multiple evidence sources to establish the final security status.

Detailed guidance: `docs/07-validation-and-recovery.md`.

---

## 16. Production Change Management

Security updates should follow a controlled process appropriate to the urgency and criticality of the issue.

### Recommended change record

| Field | Description |
|---|---|
| Change ID | Internal ticket or incident reference |
| Affected assets | Hosts, applications, containers, or sites |
| Reason | PHP2Shell applicability and risk |
| Current state | Runtime, package release, architecture |
| Target state | Vendor-supported fixed package or image |
| Planned actions | Update, restart, validation, monitoring |
| Dependencies | Extensions, application compatibility, service dependencies |
| Test plan | Staging checks and production smoke tests |
| Rollback plan | Approved recovery procedure |
| Validation evidence | Package status, runtime checks, logs, test results |
| Approver | Authorized change owner |
| Completion time | Timestamp and time zone |
| Residual risk | Outstanding gaps and accountable owner |

### Emergency changes

When the risk justifies emergency action, follow the organization's emergency-change process. Record the rationale, approvals, actions, and validation evidence as soon as practical.

Do not bypass basic safeguards such as verifying package provenance, understanding service dependencies, and retaining a recovery plan.

---

## 17. Limitations and Known Gaps

This repository is a practical starting point, not a complete vulnerability-management platform or forensic suite.

### Technical limitations

- Upstream fixed versions and vendor backports can change.
- PHP CLI and web-serving runtimes may differ.
- Configuration layouts vary by distribution and hosting provider.
- A local inventory cannot always see provider-managed runtimes.
- Log formats and available telemetry vary by environment.
- Detection rules can produce false positives and false negatives.
- Logs may be incomplete, rotated, altered, or unavailable.
- Temporary mitigations can affect application behavior.
- Script output may require manual review and environment-specific adaptation.

### No universal safety claim

The repository does not claim that a host is safe merely because:

- Its reported PHP version appears fixed.
- A log detector produces no matches.
- A configuration check completes successfully.
- A service restarts without errors.
- A web application passes a basic smoke test.

A defensible conclusion requires verified package status, runtime coverage, appropriate configuration review, and investigation of any credible compromise indicators.

---

## 18. Security and Privacy Considerations

The assessment and response process may involve sensitive infrastructure details and user data.

### Protect evidence

- Never commit passwords, API keys, private keys, access tokens, or session cookies.
- Do not upload raw patient records or other sensitive personal information.
- Redact authorization headers, session identifiers, and personal data from shared examples.
- Restrict access to incident evidence and generated reports.
- Store evidence in approved, access-controlled locations.
- Follow retention, legal-hold, and disposal requirements.
- Avoid publishing internal hostnames, private addresses, or infrastructure diagrams without authorization.

### Handle scripts carefully

Read scripts before execution, especially those run with elevated privileges. Verify that output destinations have sufficient disk space and appropriate access controls. Do not execute copied commands from untrusted sources without understanding their effects.

### Report vulnerabilities responsibly

If you discover a new vulnerability or a previously unknown exploitation technique, report it through the relevant vendor's security-reporting channel. Do not publish secrets, sensitive evidence, or operational details that would enable unauthorized exploitation.

---

## 19. Testing and Lab Guidance

Use a disposable virtual machine, isolated container environment, or staging deployment for learning and regression testing.

### Suggested learning sequence

1. Understand PHP execution models and service architecture.
2. Inventory the runtime and identify package provenance.
3. Review vendor advisories and compare fixed-build guidance.
4. Practice configuration review using the supplied templates.
5. Run the log detector against sanitized sample logs.
6. Execute the included unit tests.
7. Simulate the administrative workflow using a harmless test application.
8. Practice evidence handling and incident documentation.
9. Verify the runtime and application after applying a supported update.
10. Write a concise assessment report documenting findings and limitations.

### Run the detection tests

From the repository root, inspect the test file and dependencies, then run:

```bash
python3 -m unittest discover -s tests -v
```

This command is appropriate if the tests use Python's standard `unittest` framework. If the repository's test implementation or dependencies differ, follow its documented test instructions.

Tests validate the behavior they cover; they do not establish that the detector identifies every attack or that the host is not vulnerable.

---

## 20. Contributing

Contributions that improve defensive reliability, documentation, and operational usability are welcome.

### Good contribution areas

- Verified vendor-advisory updates.
- Improvements to PHP runtime inventory.
- Support for additional package managers and hosting layouts.
- Better logging-format compatibility.
- Detection test cases covering benign and suspicious patterns.
- Documentation clarifications and corrections.
- More robust error handling and safe defaults.
- Reproducible tests and CI improvements.
- Accessibility and readability improvements.

### Contribution requirements

- Explain the problem and the proposed defensive benefit.
- Include tests for changes to scripts or detection rules where feasible.
- Document operating-system and dependency assumptions.
- Avoid committing secrets, personal information, or sensitive logs.
- Use sanitized sample data.
- Clearly label unverified findings and environment-specific guidance.
- Keep changes focused and reviewable.
- Do not add weaponized exploits, remote-shell payloads, or unauthorized-compromise tooling.

### Reporting issues

When opening an issue, include the relevant operating system, PHP deployment model, sanitized error output, expected behavior, and steps to reproduce the defensive-tooling issue.

Do not attach confidential incident evidence or sensitive production logs to a public issue.

---

## 21. References and Advisories

Use the following sources as starting points for verification. Confirm that each page remains current and that its technical details apply to your deployment.

1. **Canadian Centre for Cyber Security — AL26-026 (October 21, 2026)**  
   https://www.cyber.gc.ca/en/alerts-advisories/al26-026-critical-vulnerabilities-impacting-php-cve-2026-109618-cve-2026-109619

2. **Plesk — PHP2Shell vulnerability advisory and temporary mitigations**  
   https://support.plesk.com/hc/en-us/articles/44397729587351-Vulnerability-CVE-2026-109618-and-CVE-2026-109619-PHP2Shell-Remote-code-execution-in-PHP-shipped-with-Plesk

3. **Red Hat — Security Bulletin RHSB-2026-013**  
   https://access.redhat.com/security/vulnerabilities/RHSB-2026-013

4. **AWS Security Blog — Amazon Threat Intelligence identifies PHP2Shell exploitation prior to public disclosure**  
   https://aws.amazon.com/blogs/security/amazon-threat-intelligence-identifies-php2shell-exploitation-prior-to-public-disclosure-in-madpot/

5. **Official PHP website — Releases and security information**  
   https://www.php.net/

6. **Official PHP downloads**  
   https://www.php.net/downloads.php

7. **Sigma — Generic signature format for SIEM detection rules**  
   https://sigmahq.io/

### Source verification checklist

Before relying on an advisory:

- Confirm the CVE identifier and affected versions.
- Check publication and revision dates.
- Verify the fixed release or vendor backport.
- Read the deployment-specific mitigation instructions.
- Confirm that the advisory applies to the installed package and runtime.
- Record the source and date used in the remediation ticket.

If sources disagree, prioritize the authoritative advisory for the exact package or hosting platform and escalate unresolved uncertainty to the vendor.

---

## 22. Disclaimer

This repository is provided for defensive security assessment, education, and incident-response support. It is not a substitute for official vendor guidance, professional incident-response services, or an organization-specific security program.

The maintainers make no guarantee that the included scripts, templates, or detection rules are complete, suitable for every environment, or capable of identifying all vulnerable or compromised systems.

You are responsible for validating changes, obtaining authorization, protecting evidence, and following applicable legal, privacy, and operational requirements.

**The recommended outcome is a verified, vendor-supported remediation accompanied by documented validation—not merely a successful script run.**
