## Meta Evaluations

- **Purpose**: Assess the quality of the agent architecture framework itself, using the same rigor applied to app features.
- **Dimensions**: Prompts and Docs. Each is scored 0–5 with brief justification bullets.
- **Where**: Root-level `evals/meta/` and app-level mirrors `<APP_ROOT>/evals/meta/`.

### How to author a meta eval
- Use the meta evaluator prompt at `prompts/qa/meta-evaluator.md`.
- Name files: `YYYY-MM-DD-<subject>-evaluation.md` (e.g., `2025-08-12-agent-architecture-framework-evaluation.md`).
- Follow frontmatter guidance in `prompts/qa/evaluation-framework.md` (include `version`, `supersedes`, `delta_trend`).
- Keep findings concise; link raw artifacts in an `artifacts/` subfolder if needed.

### Suggested subjects
- Agent architecture framework (global)
- App-level agent guides and workflows
- Synchronization and update workflows for agent configs


