#!/usr/bin/env bash
# print used memory percentage (macOS + Linux)
if command -v memory_pressure >/dev/null; then
  memory_pressure | awk '/free percentage/ {gsub("%", "", $5); print 100 - $5}'
else
  free | awk '/^Mem:/ {printf "%d\n", ($2 - $7) / $2 * 100}'
fi
