#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <slug> [date:YYYY-MM-DD]" >&2
  exit 1
fi

slug="$1"
date_value="${2:-$(date +%F)}"

project_dir="$(pwd)"
memory_root="$project_dir/.agents/memorys"
template="$memory_root/templates/memory-template.md"
output="$memory_root/entries/${date_value}-${slug}.md"

if [ ! -f "$template" ]; then
  echo "Template not found: $template" >&2
  exit 1
fi

if [ -f "$output" ]; then
  echo "Already exists: $output" >&2
  exit 1
fi

cp "$template" "$output"
echo "Created: $output"
