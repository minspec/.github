# MinSpec Governance

## Purpose

This document defines how MinSpec makes decisions about architecture, naming, repository creation, contribution boundaries, source authority, and public positioning.

MinSpec is an independent project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

---

## Governance Priorities

MinSpec prioritizes:

1. architectural clarity
2. deterministic installation and composition
3. alignment with Symfony and Composer conventions
4. conservative repository creation
5. reduced drift in both code and documentation
6. respectful public positioning toward Symfony and the Symfony ecosystem
7. safe, bounded AI/Mate tooling
8. strict source-path and supply-chain control during incubation

---

## Public Positioning Rule

MinSpec must be presented as independent and unofficial.

MinSpec documentation must not imply that the project is:

- official Symfony
- endorsed by Symfony SAS
- maintained by the Symfony project
- a Symfony distribution
- a Symfony replacement
- a certification authority
- a fork of Symfony

Public language should make clear that MinSpec is built for Symfony applications and uses Symfony's public extension points.

---

## Decision Model

### Architectural Decisions

Architectural decisions should favor long-term semantic clarity over short-term convenience.

Changes to canonical architecture documents should be reviewed carefully because they affect the entire organization.

### Repository Creation Decisions

A new repository should not be created just because a concept exists.

A repository should only be created when:

- its installable responsibility is clear
- its boundary is expected to remain stable
- it does not duplicate an existing package
- it reflects developer-facing reality
- it can be validated inside the workbench or another real Symfony host

### Naming Decisions

Naming is part of architecture.

Package and repository names should align with:

- Symfony conventions
- Composer conventions
- the actual install surface
- stable developer understanding
- the independent/unofficial project posture

Names that could imply official Symfony status require extra caution.

---

## Authority Model

For now, MinSpec is founder-controlled and architect-led.

That means:

- canonical doctrine is centralized
- naming changes are high-sensitivity changes
- speculative repo proliferation should be resisted
- architecture-first review is expected for major structural changes
- public positioning changes should be reviewed for Symfony/MinSpec distinction
- public visibility does not imply public write access or contributor authority
- AI/security tools may generate evidence, but they do not approve, merge, or mutate authority

MinSpec may be publicly visible before it is publicly governable.

---

## Incubation Contribution Boundary

During incubation, MinSpec does not accept unsolicited external contributors, code pull requests, documentation pull requests, package submissions, recipe submissions, workflow changes, dependency changes, or AI-generated contribution patches.

The project may accept:

- questions
- reproducible bug reports
- security reports through the published security process
- design feedback
- documentation clarity suggestions
- evidence that an existing claim, package boundary, or workflow is wrong

This feedback may inform maintainer decisions, but it does not create contributor status or source authority.

Unsolicited pull requests may be closed without review.

---

## Source Authority and Supply Chain Rule

Only official MinSpec repositories and explicitly approved source paths may provide code, documentation patches, workflows, package changes, recipes, or generated artifacts for trusted project use.

MinSpec should not accept trusted source material from:

- pasted code snippets
- random third-party examples
- unsolicited external pull requests
- unreviewed generated code
- unknown package sources
- unapproved dependency changes
- unapproved GitHub Actions or workflow edits
- agent-generated mutations outside a controlled source path

Security review is not a substitute for source authority.

A change must enter through an approved source path before it can be considered for inclusion.

---

## Repository-Level Ownership

This repository defines organizational defaults, but repository-specific controls may still be stricter.

Examples:

- `CODEOWNERS` should remain per-repository
- branch protections should be configured per-repository
- licenses should be managed per-repository
- release policies should be set per package
- stricter package/dependency rules may apply per repository

---

## Review Doctrine

Review should ask:

- Does this make the install surface clearer or fuzzier?
- Does this preserve package responsibility?
- Does this align with the current repository plan?
- Does this reduce drift or introduce it?
- Is this solving a real proven need?
- Does this preserve Symfony-native terminology?
- Does this preserve the Symfony/MinSpec distinction?
- Does this keep AI assistance bounded and auditable?
- Did this enter through an approved source path?
- Does this preserve contributor and mutation authority boundaries?

---

## AI/Mate Governance

Core MinSpec AI/Mate tooling should remain vendor-neutral.

AI/Mate tools should help developers inspect, understand, validate, and safely operate within MinSpec constraints.

Mutation tools require:

- explicit command boundaries
- dry-run support where practical
- idempotency where practical
- reviewable output
- no silent host-level mutation
- approved source-path control

External agent experiments must be sandboxed and treated as experiments, not MinSpec architecture.

---

## Doctrine Evolution

MinSpec doctrine should evolve, but it should not drift casually.

The risk is doctrine ossification on one side and doctrine churn on the other.

Changes should preserve a feedback loop:

- human-readable Markdown doctrine remains load-bearing
- Mate tooling reflects doctrine, not replaces it
- successful workflows can become deterministic tools
- failed assumptions should be corrected openly

---

## Reset Principle

MinSpec is intentionally willing to reset structure when the existing repo map no longer reflects the best architecture.

Archived repositories may remain for historical reference, but they should not control the new plan.
