## Docs overview

- **Purpose**: Authoritative reference for architecture, conventions, and onboarding. Start here before reading code.
- **How to use**:
  - Browse app-level docs first (replace `<APP_ROOT>` with your app root when applicable)
  - Use `docs/adr/` for architectural decisions; every significant change should reference an ADR.
  - Use `plans/` to propose and track changes. Plans must declare a Decision Path.
  - Use `evals/` to capture evidence that informs plans/ADRs.
- Templates live in `docs/templates/` (`adr.md`, `plan.md`, `eval.md`). Copy and fill them.

### Decision Path (traceability)
- Plans must include:
  - "Decision recorded in: docs/adr/00xx-...md"
  - "Evidence from eval(s): links to evals/...md"
- ADRs must link back to the initiating plan and relevant evals.


