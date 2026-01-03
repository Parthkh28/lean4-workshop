# Claude Code Instructions for lean4-workshop

## Project Overview

This is a Lean 4 workshop repository for learning theorem proving and functional programming.

## Toolchain Familiarity

Agents should be familiar with these tools:

```bash
# Repository management
man ghq               # Go get for repositories
ghq list              # List managed repos
ghq root              # Show ghq root directory

# GitHub CLI
man gh                # GitHub CLI
gh repo view          # View current repo
gh pr create          # Create pull request

# Git
man git               # Version control
git worktree list     # List worktrees

# Beads issue tracking (v0.43.0)
bd quickstart         # Get started with beads
bd ready              # Find available work
bd gate discover      # Auto-discovery for gh:run await_id
bd gate add-waiter    # Phase handoff support
bd gate show          # Show gate details
```

## Tmux for Background Jobs

**Prefer tmux for long-running jobs and agents:**

```bash
# Create named session for agents
tmux new-session -d -s lean-build "gmake build"
tmux new-session -d -s verifier "lean exercises/*.lean"

# Attach to check progress
tmux attach -t lean-build

# List sessions
tmux list-sessions
```

## Agent Identity & Governance

### Identity Chain
Human → Git → Persona → LLM attribution

### Six Essences (Ontology)
| Essence | Role |
|---------|------|
| Implementer | Writes code/proofs |
| Validator | Verifies correctness |
| Observer | Reviews structure |
| Architect | Designs systems |
| Interpreter | Explains/documents |
| Catalyst | Initiates change |

### Governance
Adversarial two-pass review: independent agents review before merge.

## File Format Rules

- **Use org-mode** (`.org`) for all documentation and notes
- **Exceptions**: AGENTS.md, CLAUDE.md (tooling compatibility)
- **Lean files**: `.lean` for proofs and code
- **No markdown** except the two exceptions above

## Development Practices

### Experiment-Driven Development

1. State hypothesis before implementing
2. Create small experiments to test assumptions
3. Document outcomes in beads issues
4. Iterate based on findings

### Progressive Commit Protocol

Commit in logical stages using conventional commits:
- `chore:` - setup, config
- `wip:` - work in progress (uses `sorry`)
- `feat:` - complete feature/proof
- `fix:` - corrections
- `refactor:` - cleanup
- `docs:` - documentation

### PERT Estimation

When creating beads issues, use PERT formula:
```
Expected = (Optimistic + 4×Likely + Pessimistic) / 6
```

Use `-e <minutes>` flag with `bd new`.

## Lean 4 Specific

### Verify Before Commit

```bash
gmake check           # Quick verification
lean <file>.lean      # Check specific file
lake build            # Full build
```

### Common Proof Patterns

- `rfl` - reflexivity
- `simp` - simplification
- `exact` - provide exact term
- `constructor` - split conjunction
- `induction` - mathematical induction
- `cases` - case analysis
- `omega` - linear arithmetic
- `sorry` - placeholder (WIP only)

## Beads Issue Tracking (v0.43.0)

```bash
bd quickstart         # Get started
bd ready              # Find work
bd new "title" -t task -e 30 -l label  # Create issue
bd update <id> -s in_progress          # Start work
bd close <id> -r "reason"              # Complete
bd sync               # Sync with git

# New features in 0.43.0
bd gate discover      # Auto-discovery for gh:run
bd gate add-waiter    # Phase handoff
bd gate show          # Show gate details
```

## Quality Gates

Before pushing:
1. All `.lean` files compile without errors
2. No `sorry` in completed proofs (exercises excepted)
3. `gmake check` passes
4. Beads issues updated
5. Two-pass review for significant changes
