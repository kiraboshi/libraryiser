---
title: Evaluation Framework
type: guide
owner: @maintainers
status: draft
created: 2025-08-12
last_updated: 2025-08-12
---

## Purpose

Define a lightweight, consistent workflow for updating and archiving evals so changes are traceable over time. This framework applies to root-level `evals/` and app-level `<APP_ROOT>/evals/`.

## Trigger: content difference, not status

Superseding an eval is triggered by a material content difference, regardless of the eval's outcome/status. Examples:

- Findings materially change (adds/removals that alter scope, risks, or next steps)
- Metrics or evidence shift beyond thresholds described in `docs/quality-strategy.md`
- Safety/risk level changes in a way that affects decision-making

Non-material edits (typos, small clarifications, or content that is broadly similar) do not supersede; update in place and keep the eval version unchanged.

## Frontmatter additions for evals

Each eval remains a dated Markdown file with YAML frontmatter. Add the following keys when a new eval supersedes a previous one:

- `version`: Integer that increments with each superseding eval for the same subject
- `supersedes`: Path to the previous eval file being superseded
- `delta_trend`: positive | negative | neutral — direction of change in quality/fit (author judgment)
- `delta_summary`: Short bullets describing important content changes (optional but encouraged)

On the archived prior eval, set:

- `status: archived`
- `archived_at: YYYY-MM-DD`
- `superseded_by`: Path to the new eval

Example new eval frontmatter excerpt:

```yaml
title: <Subject> evaluation
type: eval
owner: @handle
status: draft
created: 2025-08-12
last_updated: 2025-08-12
outcome: accepted|revise|reject|investigate
version: 3
supersedes: evals/<scope>/2025-08-01-<subject>-evaluation.md
delta_trend: positive
delta_summary:
  - Expanded scenarios A and B; quality improved on task X
  - Removed prior mitigation Y; no longer applicable
links:
  prompts: [prompts/<scope>/<file>.md]
```

Example archived prior eval frontmatter excerpt:

```yaml
status: archived
archived_at: 2025-08-12
superseded_by: evals/<scope>/2025-08-12-<subject>-evaluation.md
```

## Directory and naming

- Active evals remain at `evals/<scope>/` (or `<APP_ROOT>/evals/<scope>/`) with date-prefixed filenames: `YYYY-MM-DD-<subject>-evaluation.md`
- Archived evals are moved to `evals/<scope>/archive/<YYYY>/`
- Do not rename the latest evals; rely on dates and the `OVERVIEW.md` catalog for discoverability

## Workflow

1) Author the new eval file with updated content and frontmatter, including `supersedes` and `delta_trend`.
2) Archive the prior eval using the script (below). This updates its frontmatter and moves it into `archive/YYYY/`.
3) Update `evals/OVERVIEW.md` (and any app-level overview) to link the latest eval only, plus a history link to the archive folder.
4) In the PR description, summarize material content differences (3–5 bullets) and the `delta_trend`.

## Script: supercede-eval

Cross-platform helper that performs the archival mechanics and metadata wiring.

- Shell: `scripts/evals/supercede-eval.sh`
- PowerShell: `scripts/evals/supercede-eval.ps1`

Usage:

```bash
scripts/evals/supercede-eval.sh --new evals/<scope>/2025-08-12-foo-evaluation.md \
  --prev evals/<scope>/2025-08-01-foo-evaluation.md \
  --delta-trend positive
```

```powershell
scripts/evals/supercede-eval.ps1 `
  -New evals/<scope>/2025-08-12-foo-evaluation.md `
  -Prev evals/<scope>/2025-08-01-foo-evaluation.md `
  -DeltaTrend positive
```

Behavior:

- Validates both files exist and contain a YAML frontmatter block
- Sets `status: archived`, `archived_at: <today>`, and `superseded_by: <new>` on the previous eval
- Ensures the new eval has `supersedes: <prev>` and `delta_trend: <value>`
- Moves the previous eval to `archive/<YYYY>/`

## CI validation (optional)

Add simple checks to ensure:

- If an eval includes `supersedes`, that target exists and is `status: archived` with a `superseded_by` backlink
- `evals/OVERVIEW.md` only lists non-archived evals in its catalog


