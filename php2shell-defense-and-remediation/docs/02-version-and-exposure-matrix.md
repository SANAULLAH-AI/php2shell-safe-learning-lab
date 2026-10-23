# 2. Version and exposure matrix

## Upstream release matrix

As reported by the PHP security response and government/vendor advisories on 2026-10-21:

| Branch | Fixed upstream release | Notes |
|---|---:|---|
| PHP 8.5 | 8.5.12 | Use fixed release or later patched release in this branch |
| PHP 8.4 | 8.4.27 | Use fixed release or later patched release in this branch |
| PHP 8.3 | 8.3.36 | Use fixed release or later patched release in this branch |
| PHP 8.2 | 8.2.35 | Use fixed release or later patched release in this branch |
| PHP 8.1 and earlier | End-of-life upstream | Upgrade or confirm a security backport from a trusted vendor |

Never infer safety from a numeric comparison alone. Linux vendors frequently backport security fixes without changing the upstream-looking version to the same number. Review the vendor package changelog/advisory.

## Inventory every runtime, not only `php -v`

A host can have several PHP runtimes at once:
- CLI PHP used by shell commands;
- PHP-FPM pools for different sites or PHP versions;
- Apache `mod_php`;
- `php-cgi`;
- container images and Kubernetes workloads;
- control-panel-managed runtimes (Plesk/cPanel);
- bundled PHP inside appliances, backup tools, monitoring tools or CMS products;
- staging and forgotten virtual hosts.

The included inventory script reports command-line PHP and common service/container hints. It is not a complete asset-discovery system and does not prove which binary serves a given site.

## Risk prioritization

**Highest priority**
- Internet-facing, unpatched PHP runtime;
- `mod_php` deployments identified by vendor guidance as particularly exposed;
- public upload endpoints and sites processing untrusted multipart requests;
- unsupported PHP versions without a verified backport;
- runtime shared by multiple sites or holding production secrets.

**Still important**
- Internal-only PHP services reachable from user or partner networks;
- PHP in containers that are exposed through a load balancer;
- dormant sites whose DNS still points to a live host;
- PHP embedded in third-party products.

## Asset record template

Record one row per runtime:
- hostname / cloud asset ID;
- owner and business criticality;
- internet exposure and proxy/WAF;
- serving mode (FPM, mod_php, CGI, etc.);
- exact binary/package/image digest;
- vendor and package source;
- fixed-release/backport evidence;
- patch timestamp and worker restart confirmation;
- validation evidence;
- incident review status.
