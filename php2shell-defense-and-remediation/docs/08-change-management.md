# 8. Change management template

## Change record

- **Change ID:**
- **Service / host / cluster:**
- **Business owner:**
- **Technical owner:**
- **Current PHP runtime / package / image digest:**
- **Target fixed package or verified backport:**
- **Vendor advisory URL:**
- **Exposure (public / internal / isolated):**
- **Maintenance window:**
- **Backup / snapshot verified:**
- **Rollback plan:**
- **Worker restart plan:**
- **Post-change checks:**
- **Incident investigation required (yes/no):**
- **Evidence locations:**
- **Approver:**

## Rollback caution

Rolling back to a vulnerable version reintroduces exposure. If an application breaks on the patched runtime, prefer a compatible application fix or temporary isolation over returning an internet-facing host to a vulnerable build. Any emergency rollback requires an explicit risk decision and compensating controls.
