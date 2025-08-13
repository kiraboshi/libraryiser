---
title: Prompts Evaluation Harness
type: guide
owner: @maintainers
status: draft
created: 2025-08-12
last_updated: 2025-08-12
---

## Purpose
Qualitative evaluations of prompts under `prompts/`. Each eval should assess clarity, safety, completeness, and repository fit, and recommend next steps.

Follow `prompts/qa/evaluation-framework.md` for how to supersede and archive evals when content differences are material. Encode trend via `delta_trend` in frontmatter.

## Template
Create files under `evals/prompts/` named `YYYY-MM-DD-<prompt-name>-evaluation.md` with frontmatter:

---
title: <Prompt> evaluation
type: eval
owner: @handle
status: draft
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
outcome: accepted|revise|reject|investigate
version: 1
supersedes: <optional path to prior eval>
delta_trend: positive|negative|neutral
delta_summary:
  - <optional short bullets of material changes>
links:
  prompts: [prompts/<scope>/<file>.md]
---

Sections:
- Context and intent
- Methodology (what we looked for, scenarios)
- Findings (strengths, gaps)
- Risks and safety notes
- Recommendation (outcome + next steps)


