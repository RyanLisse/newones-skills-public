#!/usr/bin/env bash
# Install the skills from this repo for Claude Code, Codex and/or Cursor.
#
#   scripts/install.sh [--target claude|agents|cursor|all] [--project DIR]
#                      [--copy] [--groups "shared dev-workflow ..."]
#                      [--with-humanlayer] [--dry-run] [--force]
#
# Default: symlink every skill folder into ~/.claude/skills (Claude Code).
#   --target agents   ~/.agents/skills  (Codex; Cursor reads it too)
#   --target cursor   ~/.cursor/skills
#   --target all      claude + agents
#   --project DIR     install into DIR/.claude/skills (or DIR/.agents/skills, ...) instead of $HOME
#   --copy            copy instead of symlink (symlinks follow `git pull`)
#   --groups          only these groups under skills/ (default: all)
#   --with-humanlayer also install humanlayer/commands and humanlayer/agents
#                     into .claude/commands and .claude/agents (Claude Code only)
#   --dry-run         print what would happen, change nothing
#   --force           replace an existing skill with the same name
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET=claude; BASE="$HOME"; MODE=link; SKILL_GROUPS=""; HL=0; DRY=0; FORCE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --project) BASE="$(cd "$2" && pwd)"; shift 2 ;;
    --copy) MODE=copy; shift ;;
    --groups) SKILL_GROUPS="$2"; shift 2 ;;
    --with-humanlayer) HL=1; shift ;;
    --dry-run) DRY=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "unknown option: $1 (see --help)" >&2; exit 2 ;;
  esac
done

case "$TARGET" in
  claude) DIRS=".claude/skills" ;;
  agents|codex) DIRS=".agents/skills" ;;
  cursor) DIRS=".cursor/skills" ;;
  all) DIRS=".claude/skills .agents/skills" ;;
  *) echo "unknown --target: $TARGET" >&2; exit 2 ;;
esac

run() { if [ "$DRY" = 1 ]; then echo "+ $*"; else "$@"; fi; }

place() { # src dest
  local src="$1" dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$FORCE" = 1 ]; then run rm -rf "$dest"; else echo "skip (exists): $dest"; return; fi
  fi
  if [ "$MODE" = link ]; then run ln -s "$src" "$dest"; else run cp -R "$src" "$dest"; fi
  echo "installed: $dest"
}

[ -n "$SKILL_GROUPS" ] || SKILL_GROUPS="$(cd "$REPO/skills" && ls -d */ | tr -d /)"

for d in $DIRS; do
  dest_root="$BASE/$d"; run mkdir -p "$dest_root"
  for g in $SKILL_GROUPS; do
    [ -d "$REPO/skills/$g" ] || { echo "no such group: $g" >&2; exit 2; }
    for s in "$REPO/skills/$g"/*/; do
      s="${s%/}"; [ -f "$s/SKILL.md" ] || continue
      place "$s" "$dest_root/$(basename "$s")"
    done
  done
done

if [ "$HL" = 1 ]; then
  for kind in commands agents; do
    dest_root="$BASE/.claude/$kind"; run mkdir -p "$dest_root"
    for f in "$REPO/humanlayer/$kind"/*.md; do place "$f" "$dest_root/$(basename "$f")"; done
  done
fi
