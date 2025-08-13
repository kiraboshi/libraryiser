---
title: Meta Evaluator Prompt
type: prompt
scope: repo-wide
owner: @maintainers
status: draft
created: 2025-08-12
last_updated: 2025-08-12
version: 2
inputs:
  - scope: repo-wide | app-level
  - subject_name: string (e.g., "agent architecture framework")
  - evaluator_handle: string (e.g., @maintainers or @your-handle)
  - links.docs: string[] (paths to key docs like `AGENTS.md`, app-level guides, ADRs)
  - links.prompts: string[] (paths to key prompt artifacts under `prompts/`)
  - links.architecture: string[] (paths to architecture overviews and component indexes)
  - scope_inventory_hints: string[] (optional keywords/paths for capability discovery, e.g., `routes/`, `srv/index.ts`, `src/features/`, `docs/*/component-overview.md`)
  - prior_eval_path: string (optional path to a prior eval being superseded)
  - outcome_hint: accepted|revise|reject|investigate (optional recommendation)
outputs:
  - eval_markdown: evals/<scope>/<YYYY-MM-DD>-<subject>-evaluation.md (per framework schema)
  - gap_matrix: structured list of gaps by dimension, with severity and ownership hints
  - risk_register: risks with likelihood/impact and mitigations
  - superseding_actions: concrete steps to archive/supersede related evals or prompts
  - docs_coverage_report: coverage matrix comparing documented topics vs scope inventory (with Diátaxis mapping)
safety:
  - Documentation-first; read-only analysis of docs, prompts, and code. Do not modify code.
  - Do not assume stack, structure, or patterns; follow `AGENTS.md`.
  - Avoid secrets/PII in outputs; link artifacts rather than embedding sensitive content.
links:
  docs:
    - AGENTS.md
    - prompts/qa/evaluation-framework.md
    - docs/engineering-standards.md
    - docs/toc.md
    - docs/prompt-registry.md
    - docs/quality-strategy.md
  prompts:
    - prompts/operators/README.md
    - prompts/operators/coding-operator.md
    - prompts/operators/docs-operator.md
    - prompts/operators/eval-operator.md
    - prompts/operators/migration-operator.md
    - prompts/operators/qa-operator.md
---

## Purpose

Provide a reusable prompt that evaluates the repository's agent architecture framework itself (meta evaluation), using the same standards we apply to app features. The evaluation MUST surface as many issues as possible across prompts, docs, governance, and operability. It outputs a Markdown eval following our evaluation framework and naming conventions, plus a structured gap matrix and risk register. Perform a read-only review of code and tests referenced by docs/prompts to validate claims.

## Inputs

- scope: repo-wide | app-level
- subject_name: e.g., "agent architecture framework"
- evaluator_handle: e.g., @maintainers or @your-handle
- links:
  - docs: [paths to key docs like `AGENTS.md`, app-level guides under `docs/`, ADRs]
  - prompts: [paths to key prompt artifacts, e.g., under `prompts/`]
- prior_eval_path: optional path to a prior eval being superseded
- outcome_hint: optional recommendation (accepted|revise|reject|investigate)

## Instructions

1) Read documentation first
   - At the specified scope, review `AGENTS.md`, root `docs/` and app-local `docs/` (including `docs/adr/`, `plans/`, `evals/`).
   - Review `docs/toc.md`, app ToCs, `docs/prompt-registry.md`, `docs/quality-strategy.md`, and `prompts/qa/evaluation-framework.md`.
   - Identify documented entry points, workflows, standards, and any process scripts (e.g., sync, eval archival).

1a) Build a scope inventory (breadth baseline)
   - Enumerate capabilities, modules, services, features, and cross-cutting domains using:
     - Architecture docs (root/app): e.g., `docs/architecture/overview.md`, `*/docs/component-overview.md`.
     - ToCs and indexes (root/app): `docs/toc.md`, `app-*/docs/toc.md`.
     - High-level code entry points: `routes/`, `srv/index.ts`, `src/features/`, `src/services/`, `api/`.
     - Plans and ADRs as signals of significant areas and decisions.
   - Normalize into groups:
     - Functional features (e.g., authentication, data ingestion, assistant, feed)
     - Platform modules/services (e.g., API, DB, workflows)
     - Cross-cutting qualities (security, performance, accessibility, reliability, observability)
     - Operational processes (release, incident response, backup/restore)

2) Review code and tests (read-only)
   - Use the doc-informed mental model to navigate implementations and tests. Start from documented entry points and key paths.
   - Verify presence and basic operability signals (static inspection) for critical scripts and assets referenced by docs/prompts:
     - Agent sync scripts: `scripts/sync-agents.(sh|ps1)`; check target lists and naming consistency.
     - Eval archival helpers: `scripts/evals/supercede-eval.(sh|ps1)`; check expected metadata wiring.
     - CI/workflows (if present): validation for prompt frontmatter, registry inclusion, ToC links, and eval supersede wiring.
   - Check that prompt files exist where referenced, include required frontmatter, and are indexed in `docs/prompt-registry.md` and ToCs.
   - Confirm app-level mirrors/guides exist when mandated (e.g., app-scoped operator READMEs) and link back to root guides.
   - Assess completeness and truthfulness: note missing artifacts, contradictions between docs and code, stale guidance, or duplicated/ambiguous targets.
   - Capture discrepancies and gaps to inform scores and recommendations. Do not execute scripts; limit to read-only verification.

3) Analyze artifacts by dimension
   - Prompts dimension:
     - Coverage (catalog breadth): Presence of core operators AND specialized operators:
       - Core: coding, docs, evaluation, migration, QA
       - Specialized: security, performance, accessibility, observability, release/change, API contract, data/schema, CI/CD, incident/postmortem
    - App-scoped variants/examples where applicable (e.g., `<APP_ROOT>`).
     - Clarity & constraints: explicit goals, scope, guardrails; safety guidance (no secrets; documentation-first).
     - Frontmatter completeness: `title`, `type: prompt`, `scope`, `owner` (non-generic), `status`, `inputs`, `outputs`, `safety`, `links`, and `version`.
     - Versioning & change policy: prompt-level versioning notes; supersede/change log policy or linkage to ADRs/plans.
     - Practicality: example invocations, acceptance checklists, runnable checklists where safe.
   - Docs dimension:
     - Completeness: required docs present (global + app-level): `AGENTS.md`, ToCs, registry, ADR templates/index, plans, evals overview, quality strategy.
     - Breadth coverage vs scope inventory: for each inventory item, verify appropriate doc types (Diátaxis) and operational docs exist.
       - Diátaxis mapping per item: tutorial, how-to, reference, explanation (as applicable).
       - Operational docs: runbooks, troubleshooting, migration notes, SLO/SLA where relevant.
     - Accuracy: alignment with code and scripts; identify contradictions, stale links, or duplicated targets (e.g., misnamed sync targets).
     - Topology & discoverability: clear root vs app mirrors; registry and ToCs include the operators catalog and app mirrors.
     - Update rules: explicit and followed (e.g., prompt additions update registry/ToCs; changes link updated docs/ADRs in PRs).
     - Operability: workflows and scripts are cross-platform (shell and PowerShell) and documented with non-interactive flags.
   - Governance & CI dimension:
     - Presence of CI or pre-commit checks for prompt frontmatter validation, registry/ToC inclusion, and eval supersede wiring per framework.
     - PR templates or checklists requiring links to updated docs/ADRs/evals.
     - Policy enforcement for owners/status on prompts (avoid permanent `@maintainers`/`draft`).
   - Operability dimension:
     - End-to-end executability: contributors can follow prompts/docs to completion without guesswork.
     - Cross-platform ergonomics: scripts callable on Windows/macOS/Linux; guidance for PowerShell/bash provided.
     - Evidence availability: examples, tests, or artifacts referenced by prompts/docs exist and are discoverable.

4) Score each dimension on a 0–5 scale
   - Minimum dimensions to score: Prompts, Docs. Also score Governance & CI and Operability when applicable.
   - 0: Missing; 1: Poor; 2: Fair; 3: Good; 4: Very good; 5: Excellent
   - Provide 2–4 bullets justifying each score; cite artifacts.
   - For Docs breadth, include quantitative signals, e.g., "N/M capabilities have at least one appropriate doc type; K have full Diátaxis coverage."

5) Synthesize risks and recommendations
   - Maintain a risk register with likelihood/impact and proposed mitigations.
   - Recommend concrete next steps tied to owners and artifacts (docs, prompts, scripts, CI) with suggested statuses.

6) Produce an eval Markdown following this schema

```markdown
---
title: <Subject> meta evaluation
type: eval
owner: <@handle>
status: draft
created: <YYYY-MM-DD>
last_updated: <YYYY-MM-DD>
outcome: accepted|revise|reject|investigate
version: <int>
supersedes: <optional path>
delta_trend: positive|negative|neutral
delta_summary:
  - <optional short bullets>
links:
  docs: [<paths>]
  prompts: [<paths>]
scope: repo-wide | app-level
---

## Context and intent

## Methodology

## Findings

### Prompts (score: X/5)
- 

### Docs (score: Y/5)
- 

#### Docs coverage summary
- Total capabilities discovered: <M>
- Documented (any doc): <N>
- Full Diátaxis coverage: <K>
- Cross-cutting domains documented (security, performance, accessibility, observability, reliability): <list>
- Operational docs present (runbooks, release, incident): <summary>

### Governance & CI (score: Z/5)
-

### Operability (score: W/5)
-

## Risks and safety notes

## Gap matrix
- Dimension → Gap → Severity → Owner → Artifact(s)

## Docs coverage report (appendix)
- Map each capability/module/domain to present/missing docs (tutorial/how-to/reference/explanation) and operational docs.

## Recommendation
- Proposed outcome: <outcome>
- Next steps:
  - 
```

7) If superseding a prior eval (when `prior_eval_path` is provided), archive it using the helper script referenced in the Evaluation Framework:

```bash
scripts/evals/supercede-eval.sh --new <new_eval_path> --prev <prior_eval_path> --delta-trend <positive|negative|neutral>
```

```powershell
scripts/evals/supercede-eval.ps1 `
  -New <new_eval_path> `
  -Prev <prior_eval_path> `
  -DeltaTrend <positive|negative|neutral>
```

## Notes

- Follow the superseding and archival policy in `prompts/qa/evaluation-framework.md`.
- Keep Results concise; store raw artifacts under `artifacts/` or link out.
- Place new evals in `evals/<scope>/` and rely on date-prefixed filenames; move superseded evals to `evals/<scope>/archive/<YYYY>/` using the script.

## Problem detectors (non-exhaustive)

- Operators catalog gaps: missing specialized operators (security, performance, accessibility, observability, release/change, API contract, data/schema, CI/CD, incident/postmortem).
- Prompt frontmatter issues: missing `owner`, `status`, `version`, or incomplete `inputs/outputs/safety/links`.
- Ownership/status drift: prompts stuck at `status: draft` with generic `owner: @maintainers`.
- Registry/ToC drift: prompts not listed in `docs/prompt-registry.md` or linked from root/app ToCs.
- Script inconsistencies: duplicated or misnamed sync targets; missing non-interactive flags in examples; lack of cross-platform paths.
- Eval governance gaps: missing `supersedes`, `delta_trend`, or archive wiring; `OVERVIEW.md` not reflecting latest evals.
- App mirrors missing: no app-scoped operator READMEs or examples where guidance mandates them.


