#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo "Running GDScript Regex Benchmark (Godot Headless)..."
godot --headless -s tests/respeedtest/regex.gd --quit

echo ""
echo "Running Lore Regex Benchmark..."
lore tests/respeedtest/regex.lore
