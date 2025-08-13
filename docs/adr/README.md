---
title: Architecture Decision Records (Index)
type: guide
owner: @maintainers
status: draft
created: 2025-08-01
last_updated: 2025-08-12
---

## Architecture Decision Records (Index)

This index lists ADRs across apps. Status and synopsis should be maintained at the top of each ADR.

### How to use
- Create new ADRs from `docs/templates/adr.md` at the appropriate scope (root or app-level).
- Keep ADRs concise with: Context → Decision → Consequences → Alternatives → Supersession.
- Include Traceability: link back to the initiating plan and supporting eval(s).

### Traceability requirements
- Every plan must declare:
  - "Decision recorded in: docs/adr/00xx-...md"
  - "Evidence from eval(s): links to evals/...md"
- Every ADR must link back to its initiating plan in a Traceability section.

| ID | Title | App | Status | Synopsis | Link |
|----|-------|-----|--------|----------|------|
| 0001 | OpenAPI-first and validation middleware | Server | TBD | Request/response validation via OpenAPI | [server 0001](../../<APP_ROOT>/docs/adr/0001-openapi-first-and-validation-middleware.md) |
| 0002 | Express with TSOA routing | Server | TBD | TSOA for route generation and types | [server 0002](../../<APP_ROOT>/docs/adr/0002-express-with-tsoa-routing.md) |
| 0003 | CORS and client origin policy | Server | TBD | Strict origin policy | [server 0003](../../<APP_ROOT>/docs/adr/0003-cors-and-client-origin-policy.md) |
| 0004 | Error handling and validation strategy | Server | TBD | Centralized error model | [server 0004](../../<APP_ROOT>/docs/adr/0004-error-handling-and-validation-strategy.md) |
| 0005 | Workflow executor and scheduler | Server | TBD | Background scheduling | [server 0005](../../<APP_ROOT>/docs/adr/0005-workflow-executor-and-scheduler.md) |
| 0001 | Use Vite | Web | TBD | Build tooling modernization | [web 0001](../../<APP_ROOT>/docs/adr/0001-use-vite.md) |
| 0002 | Server state with React Query | Web | TBD | Async state strategy | [web 0002](../../<APP_ROOT>/docs/adr/0002-server-state-with-react-query.md) |
| 0003 | Component state with XState | Web | TBD | Complex UI state via machines | [web 0003](../../<APP_ROOT>/docs/adr/0003-component-state-with-xstate.md) |
| 0004 | Custom design system over antd | Web | TBD | Migration to in-house UI | [web 0004](../../<APP_ROOT>/docs/adr/0004-custom-design-system-over-antd.md) |
| 0005 | OpenAPI-generated client and API context | Web | TBD | Typed client integration | [web 0005](../../<APP_ROOT>/docs/adr/0005-openapi-generated-client-and-api-context.md) |
| 0006 | Unit test runner — Jest now, Vitest later | Web | Accepted | Use Jest initially; keep path to Vitest open | [web 0006](../../<APP_ROOT>/docs/adr/0006-unit-test-runner-jest-now-vitest-later.md) |

Notes:
- Use statuses: proposed, accepted, superseded.
- Keep each ADR self-contained with context, decision, consequences.


