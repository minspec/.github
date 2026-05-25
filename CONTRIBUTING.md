# Contributing to MinSpec

Thank you for your interest in MinSpec.

MinSpec is an independent project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

MinSpec is currently in founder-controlled incubation.

During this phase, MinSpec is **not accepting unsolicited external contributors, code pull requests, documentation pull requests, package submissions, recipe submissions, workflow changes, or AI-generated contribution patches**.

MinSpec is public for visibility, review, reproducible feedback, and source-of-truth development. Public visibility does not imply public governance, public write access, or an open contribution process.

---

## Current Contribution Posture

MinSpec is public before it is publicly governable.

The organization may accept:

- questions
- reproducible bug reports
- security reports through the published security process
- design feedback
- documentation clarity suggestions
- evidence that an existing claim, package boundary, or workflow is wrong

The organization does **not** currently accept:

- unsolicited code pull requests
- unsolicited documentation pull requests
- third-party package implementations
- copied code snippets
- generated code from outside approved source paths
- dependency changes
- GitHub Actions or workflow changes
- broad doctrine rewrites
- AI-agent-generated mutation patches
- pull requests that imply contributor authority

Pull requests are enabled but restricted to collaborators only. Only users with repository write, maintain, or admin access may open pull requests.

Collaborator PR access is an operational mechanism for trusted maintainers and approved collaborators. It is not a public contribution path.

Opening an issue or providing feedback does not grant contribution authority, source authority, maintainer status, or approval to submit code changes.

That is not a judgment on people who provide feedback. It is a source-of-truth and supply-chain boundary for the incubation phase.

---

## Why This Boundary Exists

MinSpec is still establishing its architecture, terminology, repository map, package boundaries, AI/Mate tooling model, and public posture.

Early uncontrolled contributions would increase the risk of:

- architectural drift
- unclear ownership
- premature package creation
- copied or unreviewed code entering the trusted source path
- hidden supply-chain risk
- accidental Symfony/MinSpec positioning mistakes
- AI-generated structure replacing reviewed doctrine
- public confusion about governance authority

The current priority is to build a coherent foundation before opening any contributor model.

---

## Project Posture

MinSpec is not trying to replace Symfony.

It is a package-first architecture project built on Symfony's public extension points.

The goal is disciplined composition:

- Composer packages
- Symfony bundles
- Flex recipes
- LAST-stack defaults
- Turbo-driven UX
- focused AI/Mate developer tooling
- predictable, inspectable application growth

---

## Feedback Principles

Useful feedback should:

- preserve Symfony-native terminology
- improve clarity
- reduce drift
- respect package boundaries
- avoid speculative abstractions
- avoid unnecessary repository creation
- keep automation explicit and reviewable
- preserve the Symfony/MinSpec distinction
- include evidence where possible

Avoid feedback that:

- implies MinSpec is official Symfony
- introduces freeform AI-driven structure
- adds project-local reusable behavior that belongs in a package
- creates packages before boundaries are proven
- adds ceremony without clear value
- privileges one AI vendor in core docs or architecture

---

## Invited Work

If MinSpec explicitly invites outside work later, that work must enter through an approved source path.

Invited work may require:

- a narrow written scope
- provenance disclosure
- maintainer review
- alignment with canonical doctrine
- security and supply-chain review
- explicit approval before merge

No contributor status, project authority, or merge authority should be inferred from public discussion, issues, stars, forks, comments, or prior feedback.

---

## Package-First Rule

Reusable behavior should enter MinSpec through a package whenever possible.

If runtime Symfony integration is needed, the package should usually be a Symfony bundle.

If setup or wiring is needed, it should be automated through a Flex recipe.

If host application files must be generated, generation should be explicit, deterministic, minimal, and reviewable.

---

## Documentation Is Architecture

Documentation is part of the architecture.

When proposing documentation changes or feedback:

- keep tone disciplined, practical, and respectful
- avoid hype
- avoid official-sounding Symfony claims
- avoid autonomous AI claims
- use vendor-neutral AI language in core docs
- prefer Symfony-native terms over invented terms

---

## AI-Assisted Work

AI-assisted analysis may be useful as review input.

AI agents, GitHub Apps, bots, automation, Dependabot, Copilot agents, browser agents, and external tools are not maintainers and do not gain source authority from collaborator-only PR settings.

AI-generated code, documentation patches, workflow changes, or repository mutations are not accepted from unapproved external sources during incubation.

The MinSpec rule remains:

> **AI reasons. MinSpec commands mutate.**
