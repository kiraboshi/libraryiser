---
title: Evals Overview and Catalog
type: guide
owner: @maintainers
status: draft
created: 2025-08-12
last_updated: 2025-08-12
---

## Evals Overview

Catalog of qualitative evaluations across the repository. Outcome tags indicate recommended next steps.

See `prompts/qa/evaluation-framework.md` for the authoritative workflow on updating and archiving evals. Superseding is driven by material content differences, not status, and deltas are encoded in frontmatter via `delta_trend`.

### Outcome tags
- accepted: adopt recommendation
- revise: modify and re-evaluate
- reject: do not adopt
- investigate: gather more evidence

### Catalog (selected)
- Prompts
  - See `evals/prompts/README.md`

- Meta


### History policy

- Latest evals are listed here. Prior versions are archived under `evals/<scope>/archive/<YYYY>/`.
 - Each new eval should include `supersedes: <path>` and `delta_trend: positive|negative|neutral`.
 - Archived evals set `status: archived`, `archived_at: <date>`, and `superseded_by: <path>`.


