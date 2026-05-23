# MinSpec Org Governance

This repository contains the default community health files and the canonical governance documents for the MinSpec organization.

It is the constitutional repository for the organization, not an implementation repository.

MinSpec is an independent project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

---

## Purpose

This repository exists to define:

- the public organization profile
- contribution, security, and support defaults
- MinSpec architectural doctrine
- repository planning and naming rules
- MinSpec terminology
- the current AI/Mate development strategy
- the package-first composition model
- incubation governance and source-authority boundaries

---

## Scope

This repository **does not** contain:

- application code
- bundle code
- Symfony Flex recipes
- runtime implementation details
- example applications

Those belong in the installable repositories they describe.

---

## Incubation Contribution Posture

MinSpec is currently founder-controlled and architect-led.

During incubation, MinSpec is **not accepting unsolicited external contributors, code pull requests, documentation pull requests, package submissions, recipe submissions, workflow changes, dependency changes, or AI-generated contribution patches**.

Public feedback may still be useful. Public write authority is not open.

The project may accept:

- questions
- reproducible bug reports
- security reports through the published security process
- design feedback
- documentation clarity suggestions
- evidence that an existing claim, package boundary, or workflow is wrong

Unsolicited pull requests may be closed without review.

This boundary protects MinSpec's source-of-truth, supply-chain posture, doctrine integrity, and early architecture while the foundation is still being established.

---

## Canonical Documents

- `ARCHITECTURE.md` — top-level architectural doctrine
- `TERMINOLOGY.md` — stable vocabulary for MinSpec
- `REPOSITORY_PLAN.md` — which repositories exist now, next, later, and not yet
- `REPOSITORY_TAXONOMY.md` — repo categories and lifecycle rules
- `PACKAGE_NAMING.md` — naming rules for repos, packages, bundles, and recipes
- `AI_STRATEGY.md` — MinSpec AI/Mate development and runtime doctrine
- `GOVERNANCE.md` — organizational governance and decision model

---

## Default Community Health Files

These files are intended to serve as organization-wide defaults where GitHub supports them:

- `CODE_OF_CONDUCT.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `SUPPORT.md`
- `PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/*`

---

## Public Org Profile

The public organization profile is defined by:

- `profile/README.md`

The profile README is the primary public-facing explanation of MinSpec.

It should preserve three ideas:

1. MinSpec is built with respect for Symfony.
2. MinSpec is independent and unofficial.
3. MinSpec is package-first, Symfony-native, and AI-aware without being AI-led.

---

## Current Repository Status

The currently functional MinSpec repositories are:

- `minspec/.github`
- `minspec/skeleton`

The intended MinSpec repository/package design also includes:

- `minspec/workbench`
- `minspec/recipes`
- `minspec/ai-mate-extension`
- `minspec/ui-bundle`
- `minspec/dashboard-bundle`
- `minspec/standards`

These planned repositories remain part of the doctrine, but they should not be described as fully implemented until they actually exist and work.

---

## Current Direction

MinSpec is being reset around a smaller, clearer foundation:

- one canonical skeleton
- package-first composition
- reusable Symfony bundles
- a separate recipes repository
- a maintainer workbench for validating package and recipe behavior
- a vendor-neutral AI/Mate extension for development-time assistance
- a UI bundle / MinSpec UI layer baseline for modern Symfony UX
- runtime AI treated as a separate concern from development tooling

The short version:

> **Start by installing the capability that owns the concern.**

The project should avoid copy-paste architecture, speculative package sprawl, and freeform AI-generated structure.

---

## Current Roadmap

1. `workbench`
2. `ai-mate-extension` baseline
3. `ui-bundle` / MinSpec UI layer baseline
4. `dashboard-bundle` first usable version
5. Hermes Agent sandbox experiment
6. recipe ownership metadata
7. richer Mate tools
8. optional `mate-observer` later

See `REPOSITORY_PLAN.md` and `AI_STRATEGY.md` for the current plan.

---

## Related Research Space

- [`minspec`](https://huggingface.co/minspec) — planned space for Symfony-focused datasets, model experiments, and research artifacts for improving AI-assisted Symfony development

If the Hugging Face organization has not yet been created, keep this link under review.
