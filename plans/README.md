## Plans

- **Purpose**: Proposals and implementation guides for upcoming changes.
- **Structure**: Plans are organized by current state:
  - [`drafts/`](./drafts/) — early-stage ideas and rough proposals
  - [`pending/`](./pending/) — proposals awaiting implementation
  - [`in-progress/`](./in-progress/) — actively being worked on, with each plan in its own container folder at `in-progress/plan-name/` containing the plan specification and any other working context required for plan execution
  - [`completed/`](./completed/) — finished implementations

### Current Plan States

**Drafts:**
*(No drafts currently)*

**In Progress:**
- [tRPC Migration](./in-progress/tsoa-to-trpc-migration/) - Phase 3 (Controller Migration) - 100% Complete
- [Docs Standards Rewrite](./in-progress/docs-standards-rewrite/)
- [Documentation Uplift](./in-progress/documentation-uplift/)
- [Monorepo Management](./in-progress/monorepo-management/)

**Pending:**
- [EffectTS Migration](./pending/effectts-migration.md)

**Completed:**
- [tRPC Migration Phase 1-2](./completed/trpc-migration-plan.md)

### How to use
- Start with early ideas in `drafts/` using a rough format (can be less formal than the template).
- Create a new file from `docs/templates/plan.md` when promoting from drafts to `pending/`.
- Fill Purpose, Problem, Proposed Approach, Impact, Risks, and Success Metrics.
- Add the Decision Path block with links to the ADR and supporting evals.
- Keep status and `last_updated` current; link related PRs.
- Move plans between folders as their state changes: `drafts/` → `pending/` → `in-progress/` → `completed/`.
- In-progress plans are stored in container folders at `in-progress/plan-name/` containing the plan specification and any other working context required for plan execution.

### Decision Path (required)
- "Decision recorded in: docs/adr/00xx-...md"
- "Evidence from eval(s): links to evals/...md"


