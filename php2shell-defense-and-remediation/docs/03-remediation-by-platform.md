# 3. Remediation by platform

## General order of operations

1. Identify all PHP runtimes and their owners.
2. Snapshot current package/configuration information; back up configuration and verify recovery.
3. Read the exact OS/hosting-vendor advisory.
4. Apply the vendor-supported patched package or upgrade.
5. Restart/reload all affected PHP workers and web server processes as directed.
6. Confirm the runtime used by the site is patched.
7. Check error logs and availability.
8. Search logs/processes/files for signs of exploitation; patching does not remove an existing foothold.
9. Document the change, evidence and rollback plan.

## Debian / Ubuntu

Use the distribution's security update process and package source. Example *workflow*:

```bash
sudo apt update
apt-cache policy php8.3-cli php8.3-fpm
sudo apt list --upgradable 2>/dev/null | grep -E '^php|libapache2-mod-php'
```

If the vendor has published fixed packages, upgrade the exact packages used by your deployment. Package names differ by branch and installed modules. Do not blindly run a broad upgrade on a production server without the normal change process.

After patching, restart the actual service, for example:

```bash
sudo systemctl restart php8.3-fpm
sudo systemctl reload nginx
```

Only use service names that exist on the host. Apache `mod_php` uses a different service/restart path. Check package changelogs and vendor advisories for backports.

## RHEL / Rocky / AlmaLinux / Oracle Linux / Amazon Linux

Check the vendor's security bulletin and enabled repositories. Example inspection:

```bash
rpm -qa | grep -E '^php|^php[0-9]'
dnf updateinfo list security | grep -i php
dnf info php php-fpm
```

Apply the relevant vendor update and restart the matching FPM/web-server services. Remi, third-party repositories and control panels may package PHP differently; confirm the origin of every package.

## Docker / Podman

1. Identify every running container/image containing PHP.
2. Update the base image to a fixed supported tag/digest approved by the vendor.
3. Rebuild the image; do not merely patch a running container manually.
4. Scan dependencies and image layers.
5. Deploy the new image, confirm the rollout and retire old replicas.
6. Confirm the deployment controller is not restarting old images.

Useful inventory commands:

```bash
docker ps --format '{{.ID}} {{.Image}} {{.Names}}'
docker images --digests
docker inspect --format '{{.Name}} {{.Config.Image}}' $(docker ps -q)
```

These commands inspect local Docker state; they do not prove that an image has the fix. Verify the image's PHP package/build and digest.

## Kubernetes

- Enumerate Deployments, StatefulSets, DaemonSets, Jobs and CronJobs.
- Map each image to its source repository and PHP version.
- Rebuild and redeploy patched images.
- Verify all pods have rolled over; no old ReplicaSet or Job should keep a vulnerable image running.
- Check admission policies and image scanning to prevent reintroduction.
- Review ingress and application logs for suspicious activity.

Example read-only inventory:

```bash
kubectl get deploy,statefulset,daemonset,job,cronjob -A -o wide
kubectl get pods -A -o custom-columns='NS:.metadata.namespace,NAME:.metadata.name,IMAGE:.spec.containers[*].image'
```

## Plesk / cPanel / managed hosting

Use the control panel's vendor advisory and update mechanism. The panel may manage several PHP versions separately from system PHP. Confirm every domain's assigned handler/version and all installed runtime packages. A host-level `php -v` can show a different version than the site's runtime.

For managed hosting, open an urgent support ticket and request written confirmation of:
- runtime version and patch/backport status per domain;
- worker restart completion;
- container or pool coverage;
- any recommended temporary controls;
- incident log review if exposure existed before patching.

## Windows

Inventory all IIS/FastCGI or Apache PHP deployments, including each `php-cgi.exe` path. Update from the trusted vendor/package source, update all configured PHP directories, restart the appropriate application pools/services, and verify the active binary. Do not replace a DLL or executable from an unknown download.

## After patching

- Check the serving runtime through hosting configuration or a temporary access-controlled diagnostic endpoint.
- Remove the diagnostic endpoint immediately after verification; do not leave `phpinfo()` publicly accessible.
- Confirm every worker was restarted.
- Check logs for new crashes, 5xx spikes and suspicious child processes.
- If the host may have been compromised, follow the incident response guide rather than treating patching as a complete recovery.
