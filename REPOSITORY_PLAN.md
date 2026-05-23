# MinSpec Repository Plan

This document defines the current repository reset plan for the MinSpec organization.

The goal is to create only the repositories whose responsibilities are already clear, and defer speculative boundaries until they are proven.

MinSpec is an independent project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

---

## Current Functional Repositories

Only these repositories should be treated as functional foundation repositories right now:

### `minspec/.github`

Purpose:

- organization profile
- default community health files
- canonical governance and architecture documents
- terminology and naming doctrine

Status:

- functional foundation repository

### `minspec/skeleton`

Purpose:

- canonical MinSpec project shell
- minimal baseline application
- starting point for new MinSpec applications
- first-run MinSpec setup guide / journey map

Status:

- functional foundation repository

Notes:

- The skeleton should remain intentionally small.
- It is not a full distribution or product template.
- Its default page should orient developers around Shell → Capability → Wiring → Ownership → Product.

---

## Created but Not Implementation-Complete

These repositories exist, but they should not be described as broadly functional implementation repositories yet.

### `minspec/minspec`

Purpose:

- canonical Composer namespace anchor for `minspec/*`
- public package identity for MinSpec
- future possible curated metapackage

Status:

- created, intentionally minimal, not currently an implementation package

Notes:

- This repository must not be described as a working framework, distribution, bundle, or runtime implementation.
- If it becomes a metapackage later, that role should remain explicit and curated.

### `minspec/recipes`

Purpose:

- Symfony Flex recipe policy and endpoint-stub repository
- deterministic installation-time wiring model for future MinSpec packages
- future recipe ownership metadata

Status:

- created policy / endpoint-stub surface
- no public recipe catalog yet

Notes:

- Do not add placeholder recipes.
- A recipe should exist only when there is a real MinSpec package with a real installation contract.
- This repository should not be described as a fully functional recipe catalog until real recipes exist and work.

### `minspec/discussions`

Purpose:

- public discussion/index surface, if retained
- questions, design feedback, documentation clarity suggestions, and reproducible evidence

Status:

- created discussion surface only
- not source authority
- not public governance

---

## Current Planned Build Order

The intended development order is:

1. `minspec/workbench`
2. `minspec/ai-mate-extension` baseline
3. `minspec/ui-bundle` / MinSpec UI layer baseline
4. `minspec/dashboard-bundle` first usable version
5. Hermes Agent sandbox experiment
6. recipe ownership metadata
7. richer Mate tools
8. optional `minspec/mate-observer` later

This order is intentional.

The workbench comes first after the functional foundation because MinSpec needs a real maintainer host application where packages, recipes, Mate tools, UI layers, and dashboard surfaces can be developed and tested together.

---

## Planned Foundation Repositories

### `minspec/workbench`

Purpose:

- maintainer host application for validating package-and-recipe install paths inside a real MinSpec environment
- Mate-enabled working environment for MinSpec contributors
- integration target for MinSpec packages under active development
- proving ground for UI, dashboard, recipes, and AI/Mate tooling

Status:

- planned next priority

Notes:

- Workbench is not the public starter app.
- Reusable behavior that originates here should be extracted into a package when the boundary is proven.

### `minspec/ai-mate-extension`

Purpose:

- MinSpec development-time AI/Mate integration
- Mate/MCP tools, resources, prompts, and instructions
- doctrine propagation for AI assistants
- package-shape and architecture validation

Status:

- planned after workbench baseline

Notes:

- Vendor-neutral core package.
- Vendor-specific adapters may exist separately.

### `minspec/ui-bundle`

Purpose:

- reusable MinSpec UI bundle
- MinSpec UI layer foundation
- LAST-first web UI defaults
- Symfony UX-style asset/controller integration
- Turbo-driven UI patterns

Status:

- planned after ai-mate-extension baseline

### `minspec/dashboard-bundle`

Purpose:

- reusable operational UI surface built on the MinSpec UI layer
- first practical dashboard surface
- possible visualization point for selected truth/health surfaces

Status:

- planned after ui-bundle / MinSpec UI layer baseline

### `minspec/standards`

Purpose:

- reusable coding standards
- static analysis baselines
- architectural rule support
- CI and validation conventions

Status:

- useful foundation package, but not ahead of the workbench / Mate / UI path unless needed

---

## Planned Experiments

### Hermes Agent Sandbox Experiment

Purpose:

- test whether an external agent runtime can safely consume MinSpec Mate/MCP tools
- discover workflows worth promoting into deterministic tools

Status:

- planned after first dashboard work

Security constraints:

- Docker sandbox required
- restricted egress
- no raw host access
- no production secrets
- no writable access to real MinSpec repos by default
- must integrate through MinSpec Mate/MCP tools in workbench

---

## Later / Deferred Repositories

### `minspec/api-bundle`

Create when:

- the reusable API surface is clearly defined
- multiple projects need the same installable API behavior

### `minspec/user-bundle`

Create when:

- reusable account/user functionality is clearly shared across projects

### `minspec/user-oauth-bundle`

Create when:

- external identity/social auth is clearly optional and separable from the base user package

### `minspec/agent-runtime-bundle`

Create when:

- MinSpec has a clearly defined reusable runtime AI layer
- runtime AI boundaries are proven separately from development-time Mate tooling

### `minspec/mate-observer`

Create when:

- observational AI/Mate workflows are proven useful
- the package can remain bounded, inspectable, and safe

---

## Deferred — Do Not Recreate Yet

The following names are intentionally deferred because they are too abstract, too mechanism-centric, or not yet justified as standalone installable units:

- `maker`
- `mcp`
- `core`
- `runtime`
- `kernel`
- `contracts`
- `buffer`

These may remain archived, but they are not part of the new primary repository plan.

---

## Rules for New Repository Creation

A new repository should only be created when all of the following are true:

1. The installable responsibility is clear.
2. The boundary is expected to remain stable.
3. The package is reusable or strategically necessary as its own unit.
4. The name reflects developer-facing responsibility, not internal theory alone.
5. The repo does not duplicate another repo's responsibility.
6. The repo can be validated inside the workbench or an equivalent real Symfony host.

---

## Reset Doctrine

The reset is deliberately conservative.

MinSpec should prefer:

- fewer repos with clearer boundaries
- alignment with Symfony and Composer conventions
- deferred creation over speculative creation
- explicit composition over architectural sprawl
- package-first design over project-local drift
- human-readable doctrine over hidden tooling behavior
