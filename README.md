## doc-framework — Documentation-First Repo Guide

A documentation-first, code-second framework. Start with docs, confirm in code, align with plans and evaluations. See `AGENTS.md` for the single source of truth.

### Quick start

- **Explore docs**: read `docs/README.md`, `docs/adr/README.md`, `plans/README.md`, `evals/README.md`.
- **Sync agent guides (after editing `AGENTS.md`)**:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agents.ps1
# Dry run
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agents.ps1 -DryRun
```

```bash
bash scripts/sync-agents.sh
# Dry run
bash scripts/sync-agents.sh --dry-run
```

### Repository structure

- **`docs/`**: project-wide docs (architecture, conventions, onboarding)
  - **`docs/adr/`**: Architecture Decision Records (index in `docs/adr/README.md`)
  - **`docs/templates/`**: starter templates (`adr.md`, `plan.md`, `eval.md`)
- **`plans/`**: proposals and implementation guides (see `plans/README.md`)
- **`evals/`**: evidence and results informing decisions (see `evals/README.md`)
  - **`evals/meta/`**: meta-evaluations of the framework itself
- **`prompts/`**: authoring aids for docs and evaluations
  - `prompts/documentation/*`, `prompts/qa/*`, `prompts/meta/*`
- **`scripts/`**: helper automation
  - `scripts/sync-agents.(ps1|sh)` — sync `AGENTS.md` into agent-specific files
  - `scripts/evals/supercede-eval.(ps1|sh)` — archive and wire eval frontmatter

### Core workflow (Decision Path)

1) **Read docs first**: app-local docs (if applicable), then root `docs/` and `docs/adr/`.
2) **Change code** in small, verifiable steps with tests/examples.
3) **Record decisions** with ADRs; **propose** via `plans/`; **capture evidence** in `evals/`.
4) **Keep docs current** in the same PR (see Documentation Update Rules in `AGENTS.md`).

Traceability requirements:
- Plans include: `Decision recorded in: docs/adr/00xx-...md` and `Evidence from eval(s): links to evals/...md`.
- ADRs link back to the initiating plan and related evals.

### Eval supersede (archive + link wiring)

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/evals/supercede-eval.ps1 -New <new-eval.md> -Prev <prev-eval.md> -DeltaTrend <positive|negative|neutral>
```

```bash
bash scripts/evals/supercede-eval.sh --new <new-eval.md> --prev <prev-eval.md> --delta-trend <positive|negative|neutral>
```

### Path anchoring

- Treat the repository root as the single source of truth for paths in docs, prompts, and scripts.
- Use forward slashes in docs; commands resolve paths from the repo root.

### Contributing

- Follow `AGENTS.md` global rules and PR checklist.
- Update docs/ADRs/evals in the same PR as code changes.
- After editing `AGENTS.md`, run the sync script and commit resulting updates.


