#!/usr/bin/env python3
"""Offline heuristic log triage. Reads local text files; never contacts a host."""
import argparse
import re
from pathlib import Path

PATTERNS = [
    ("multipart POST", re.compile(r"\bPOST\b.*multipart/form-data", re.I)),
    ("upload progress marker", re.compile(r"PHP_SESSION_UPLOAD_PROGRESS", re.I)),
    ("PHP fatal/out-of-memory hint", re.compile(r"out of memory|Allowed memory size|Fatal error|segmentation fault", re.I)),
    ("suspicious process keyword (if in process/audit log)", re.compile(r"\b(?:php-fpm|php-cgi|apache2|httpd)\b.*\b(?:/bin/sh|bash -c|curl |wget |python -c|perl -e)\b", re.I)),
    ("possible web-shell filename (heuristic)", re.compile(r"\b(?:shell|cmd|wso|c99|r57)\.php\b", re.I)),
]

def scan(path: Path):
    findings = 0
    with path.open("r", encoding="utf-8", errors="replace") as handle:
        for lineno, line in enumerate(handle, 1):
            labels = [label for label, pattern in PATTERNS if pattern.search(line)]
            if labels:
                findings += 1
                print(f"{path}:{lineno}: {', '.join(labels)}")
                print("  " + line.rstrip()[:500])
    return findings

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("logs", nargs="+", type=Path, help="Local log files to scan")
    args = parser.parse_args()
    total = 0
    for path in args.logs:
        if not path.is_file():
            print(f"SKIP: not a regular file: {path}")
            continue
        total += scan(path)
    print(f"\nCandidate lines: {total}")
    print("Heuristic only: review context; ordinary traffic may match and sophisticated attacks may not.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
