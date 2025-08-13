# AGENTS.md — Repository Agent Guide

This document defines how agents and contributors operate across the entire system. It establishes a documentation-first, code-second workflow and a single set of norms that app-level guides must extend, not contradict.

Keep this guide current. When you change behaviors, structures, or standards, update the relevant documentation as part of the change.

## Scope and Sources of Truth

Follow this order of operations for any task:

1. Documentation (authoritative): discover facts here first.
2. Code (confirm and refine): validate docs, read implementations and tests.
3. Plans and evaluations: align with current proposals and quality signals.

Do not assume stack, structure, or patterns. Find them in documentation first.

## Documentation Topology

Root-level documentation lives at:

- `/docs` — project-wide documentation (architecture, conventions, onboarding)
- `/docs/adr` — Architecture Decision Records (authoritative design choices)
- `/evals` — qualitative evaluations of structures and functionalities
- `/plans` — proposals and the current state of implementing proposals

This structure is mirrored inside each app folder. Examples:

- `app-web/docs`, `app-web/docs/adr`, `app-web/evals`, `app-web/plans`
- `app-srv/main/docs`, `app-srv/main/docs/adr`, `app-srv/main/evals`, `app-srv/main/plans`

When working within an app, start with that app’s local docs, then consult root docs for cross-cutting standards.

## Quick links

- Root ToC: [docs/toc.md](./docs/toc.md)
- Server ToC: [app-srv/main/docs/toc.md](./app-srv/main/docs/toc.md)
- Web ToC: [app-web/docs/toc.md](./app-web/docs/toc.md)

## Path anchoring (treat the repository root as the single source of truth)

- All paths in docs, prompts, scripts, and tool calls are relative to the repository root.
- Do not re-prefix the top-level label shown in tree snapshots. If a tree view shows `app/` as the root label, that is the repository root — do not write `app/app-web/...`.
- Use forward slashes in docs and prompts; tools should normalize on the host OS.

Examples

- Correct (relative to repo root):
  - `app-web/evals/meta/2025-08-12-app-web-docs-meta-evaluation.md`
  - `app-srv/main/docs/toc.md`
  - `prompts/operators/qa-operator.md`
- Incorrect (double-prefixed):
  - `app/app-web/evals/meta/...`
  - `app/app-srv/main/docs/...`

Preflight checks before creating or referencing files

- Existence-first: list or glob for sibling artifacts to confirm canonical directories (e.g., glob `app-web/evals/**/*.md`).
- Parent directory validation: ensure the parent folder exists; if not, reassess the anchor rather than creating a parallel structure.
- Consistency: use the same root-anchored path across all tool calls in a task.

Tip for Windows/PowerShell

- When running scripts, resolve paths from the workspace root (e.g., `pwsh -NoProfile -File scripts/evals/supercede-eval.ps1`). Avoid absolute local machine paths in docs; prefer repo-root relative paths.

## How to Understand Any Area (Workflow)

1) Read documentation

- At app scope: start in `<app>/{docs,docs/adr,evals,plans}`.
- At repo scope: read `/docs` and `/docs/adr` for global policies; review `/plans` and `/evals` for current direction and quality signals.
- Prefer architecture and ADR pages for the canonical description of structure, technology choices, and tradeoffs.

2) Analyze relevant code

- Use the doc-informed mental model to navigate the code. Start from documented entry points and key paths.
- Read tests and example usages to confirm behaviors and edge cases.

3) Align with proposals and evaluations

- If a plan is in progress, follow its guidance. If unclear or stale, propose an update (see Documentation Update Rules).

## Global Rules for Agents

- Documentation-first: never assume technology stack, file layout, or patterns without checking docs.
- Code as confirmation: read the implementation after the docs to validate details and edge cases.
- Prefer app-local standards when operating inside an app; use root standards for cross-cutting concerns.
- Keep changes small, typed/validated, and consistent with documented conventions.
- Avoid introducing parallel patterns or tools without an ADR.
- Do not pin library versions in narrative docs; consult manifest files (e.g., `package.json`, `pyproject.toml`, `go.mod`).

### Evaluation Authoring Rules (Non-negotiable)

- Never author evaluation findings or metrics directly from assumptions. Always analyse current source to produce qualitative justifications.
- When an evaluation is requested, you must execute the evaluation operator as a subagent and follow the evaluation framework. Do not bypass the operator to write eval content by hand, except for mechanical wiring (links, supersede metadata).
- Superseding is process-bound: use the provided script to archive and wire metadata. Do not hand-edit archive fields.

## Synchronization Across Agent Configs

`AGENTS.md` is the single source of truth for agent behavior. After editing this file, synchronize it to the various agent configuration files so all coding agents consume the same guidance.

- Target files synchronized from `AGENTS.md`:
  - `.cursorrules` (Cursor)
  - `GEMINI.md` (Gemini)
  - `CLAUDE.md` (Claude)
  - `GEMINI.md` (Qwen)
  - `CODEX.md` (Codex)
  - `OPENCODE.md` (OpenCode)

Run one of the following from the repository root:

```bash
# macOS/Linux
bash scripts/sync-agents.sh

# Preview changes without writing
bash scripts/sync-agents.sh --dry-run
```

```powershell
# Windows PowerShell / PowerShell 7+
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agents.ps1

# Preview changes without writing
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agents.ps1 -DryRun
```

These scripts will:
- Ensure root-level target files exist and mirror `AGENTS.md`.
- Note: Scripts currently sync only root-level targets. App-level guides should explicitly link back to this root guide.

## Prompts

- Prompts live under the root `prompts/` directory with subfolders by scope: `web/`, `srv/`, `design/`, and cross-cutting `operators/`.
- Each prompt must include frontmatter: `title`, `type: prompt`, `scope`, `owner`, `status`, `inputs`, `outputs`, `safety`, and `links`.
- Discover prompts via `docs/prompt-registry.md`.
- The Operators Prompt Suite provides reusable functional prompts for coding, documentation, evaluation, migration, and QA under `prompts/operators/`.
- When executing changes based on a prompt, include references to the prompt and related `plans`/`docs/adr`/`evals` in your PR description.

## Evaluations (Evals) — Update and Archive Framework

- Framework: see `prompts/qa/evaluation-framework.md`.
- Supersede trigger: material content difference (not status) — e.g., substantive additions/removals, metrics/safety shifts that change recommendations.
- New eval frontmatter must include `supersedes: <path>` and `delta_trend: positive|negative|neutral` (plus optional `delta_summary`).
- Archive prior eval by setting `status: archived`, `archived_at`, and `superseded_by`, and moving it to `evals/<scope>/archive/<YYYY>/`.
- Use the helper script `scripts/evals/supercede-eval.(sh|ps1)` to perform mechanics.

### Evaluation Execution Protocol (Subagent required)

1) Run the Evaluation Operator as a subagent
- Use `prompts/operators/eval-operator.md` with inputs: subject, scope, evaluator handle, links to docs/prompts, paths to evidence artifacts, and optional `prior_eval_path`.
- The subagent drafts the eval using `prompts/qa/evaluation-framework.md` sections. You may minimally edit for formatting, but do not alter findings/metrics without updating evidence.

2) Supersede/Archive if applicable
- PowerShell (Windows):
  ```powershell
  pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/evals/supercede-eval.ps1 -New app-web/evals/2025-08-12-performance-budget-results.v2.md -Prev app-web/evals/performance-budget-results.md -DeltaTrend neutral
  ```
- Bash (macOS/Linux):
  ```bash
  bash scripts/evals/supercede-eval.sh --new app-web/evals/2025-08-12-performance-budget-results.v2.md --prev app-web/evals/performance-budget-results.md --delta-trend neutral
  ```

3) Catalog updates
- Update `evals/OVERVIEW.md` (and app-level indexes) to point to the latest eval and archive history folder.

Enforcement
- PRs that modify evals must include: links to evidence files, a note that the eval was produced via `prompts/operators/eval-operator.md`, and the supersede script invocation (if used). Reviews should reject eval changes lacking attached evidence or operator provenance.

## App-Level Guides

This section is to be completed after review.

## Implementation Playbooks (Repository-Wide)

Use these generic steps, then adapt to app-specific guides and current proposals.

1) Add or change a capability

- Read relevant ADRs and architecture/docs for the area.
- Check `/plans` for active proposals; if needed, create or update a plan.
- Implement changes in code following app-local patterns.
- Add/update tests and examples to reflect the behavior.
- Update documentation and, if the change alters architecture or policy, add or amend an ADR.
- Consider updating `/evals` with new qualitative findings.

2) Introduce or modify an integration/API

- Document the contract and failure modes in the app-level docs.
- Update architecture docs if the integration affects boundaries or data flow.
- Keep generated clients and manifest configuration out of narrative docs; link to their locations.

3) Restructure or migrate code

- Propose the change in `/plans`; add an ADR if the change is architectural.
- Provide a migration guide in the app’s `docs/` and update key paths.
- Perform the migration in small, verifiable steps with tests.

## Documentation Update Rules

Update the relevant docs in the same pull request when any of the following change:

- Architecture or boundaries (modules, services, data flows)
- Technology choices or cross-cutting policies
- Directory structure or key paths/entry points
- Behavioral contracts (APIs, component interfaces, CLI, data schemas)
- Significant UX, performance, security, or accessibility guidance

Where to update:

- Minor clarifications: edit the closest app-level `docs/*.md` page.
- Structural or cross-cutting changes: add/update an ADR in `docs/adr` (and the app-level `docs/adr` if scoped to an app).
- Planned work or migrations: create/update a proposal in `plans/` and track its status.
- Quality insights, tradeoffs, or regressions: capture in `evals/`.

Process requirements:

- Keep docs adjacent to the change; the PR should not leave them stale.
- Link code diffs to the updated docs (and ADRs) in the PR description.
- For breaking changes, include a “Migration Notes” subsection in the modified doc(s).
- If a doc appears stale or contradictory, fix it or open an issue/PR to correct it before proceeding.
- Maintain the prompt registry (`docs/prompt-registry.md`) when adding new prompts; ensure prompt frontmatter is present.

## PR Checklist (for Agents)

- Documentation-first review completed; facts discovered from docs, not assumptions.
- App-level docs updated to reflect the change (and root docs if cross-cutting).
- ADR added/updated when introducing or reversing an architectural decision.
- Plans updated when the change is part of an ongoing proposal/migration.
- Evals updated if quality characteristics or tradeoffs changed.
- Tests added/updated; behaviors confirmed against docs.
- No narrative version pinning; manifests remain the source of versions.
- Synchronization run: `scripts/sync-agents.(sh|ps1)` executed and resulting updates committed.
- Evaluations (if present):
  - Produced via `prompts/operators/eval-operator.md` in a subagent session.
  - Supersede/archival performed via `scripts/evals/supercede-eval.(sh|ps1)` (with trend noted).
  - `evals/OVERVIEW.md` and app-level indices updated.

## Security, Accessibility, and Performance

Treat these as first-class. If changes affect them, update the relevant guidance in docs and, if policy-level, in ADRs. Confirm with tests and measurements where applicable.

---

This guide is the baseline for all apps in this repository. App-specific guides must extend it and point back here. Keep it accurate.


