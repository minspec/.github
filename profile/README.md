# MinSpec

> **Developer AI Psychosis? MinSpec is just what the Doctor ordered!**

MinSpec is an independent community project focused on composing modern Symfony applications through **Composer packages, Symfony bundles, Flex recipes, LAST-stack defaults, and focused AI/Mate developer tooling**.

MinSpec is currently in its **foundation-building phase**.

The goal is not to replace Symfony, fork Symfony, or present MinSpec as an official Symfony distribution. The goal is to build a disciplined, inspectable, Symfony-native composition layer for developers who want stronger defaults, clearer package boundaries, and better tooling for modern application development.

---

## Symfony and MinSpec

MinSpec is built **for Symfony**.

It is not Symfony itself.

MinSpec is an independent community project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

MinSpec exists as an independent ecosystem project that uses Symfony’s public extension points:

- Composer packages
- Symfony bundles
- Flex recipes
- Maker-style generators
- Symfony UX conventions
- AssetMapper
- Turbo
- Stimulus
- Live Components
- Mercure
- Messenger
- Symfony-native developer tooling

MinSpec should be understood as:

> **An opinionated, unofficial package composition project for building modern Symfony applications.**

It should not be understood as:

- an official Symfony distribution
- a Symfony replacement
- a fork of Symfony
- a certification authority
- a framework competing with Symfony
- an autonomous AI app generator

MinSpec depends on Symfony being strong, stable, and extensible. The project’s purpose is to build on that foundation carefully.

---

## Purpose

MinSpec exists to explore a better way to compose modern Symfony applications.

The project is centered on a simple constraint:

> **Start by installing the capability that owns the concern.**

Reusable behavior should enter an application through a package whenever possible. If runtime Symfony integration is needed, that package should usually be a Symfony bundle. If setup or wiring is needed, it should be automated through a Flex recipe. If files must be generated into the host application, that generation should be explicit, deterministic, minimal, and reviewable.

MinSpec is not a pile of starter templates.

It is not a collection of disconnected experiments.

It is not abstraction for its own sake.

The aim is to create a focused ecosystem around:

- a canonical MinSpec application shell
- package-driven application composition
- Symfony bundles with clear ownership boundaries
- Flex recipes for predictable installation
- LAST-stack defaults for modern web applications
- Turbo-driven UX patterns
- deterministic scaffolding where needed
- focused AI/Mate tooling for developer assistance
- long-term maintainability

MinSpec is designed to reduce drift, reduce ambiguity, and make the path from **idea → architecture → installation → implementation** more deliberate and more consistent.

---

## Current Status

MinSpec is in **active foundation-building mode**.

Only these repositories should currently be treated as functional:

- [`.github`](https://github.com/minspec/.github) — organization doctrine, architecture, governance, terminology, and planning
- [`skeleton`](https://github.com/minspec/skeleton) — canonical MinSpec project shell

The intended repository/package design also includes:

- `workbench` — maintainer-only development host and proving ground
- `recipes` — Symfony Flex recipes and installation automation
- `ui-bundle` — MinSpec UI bundle and UI layer foundation
- `ai-mate-extension` — vendor-neutral MinSpec Mate/MCP development tooling
- `dashboard-bundle` — future operational UI surface built on the MinSpec UI layer
- `standards` — reusable standards, analysis, and validation support

These planned repositories should remain in the doctrine, but they should not be described as fully implemented until they actually exist and work.

The vision currently extends beyond the implementation surface. That is intentional.

This stage is about defining the architecture, terminology, package boundaries, repository roles, and developer workflow before expanding into a broader ecosystem.

The current priority is to build something durable, coherent, and worth building on.

---

## Core Direction

MinSpec is being shaped around several core principles.

### Package-First Composition

Application capabilities should be added through explicit packages rather than ad hoc project-local code.

A MinSpec package may provide reusable code, a Symfony bundle, Flex recipe automation, Maker generators, frontend assets, documentation, or Mate/MCP developer tooling.

The package owns the concern. The application composes the capability.

### Symfony-Native Boundaries

MinSpec uses Symfony terminology deliberately.

- **Package** means a Composer-distributed unit.
- **Bundle** means a reusable Symfony package with runtime framework integration.
- **UX bundle** means a Symfony bundle that ships frontend assets, controllers, or UI behavior in the Symfony UX style.
- **Recipe** means Flex automation for installation and wiring.
- **Component** means an actual UI, Twig, Live, or Stimulus component primitive inside a UI bundle.

MinSpec should not invent new terminology when Symfony already has the right word.

### Install-Driven Application Growth

Capabilities should be installed intentionally, wired predictably, and documented clearly.

Recipes should help automate setup, but they should not hide architecture.

A good MinSpec install path should be inspectable, repeatable, and reversible.

### LAST-Stack Defaults

MinSpec is especially focused on the modern Symfony LAST stack:

- **Live Components**
- **AssetMapper**
- **Stimulus**
- **Turbo**

The default web application direction is server-driven, progressively enhanced, Turbo-friendly, and compatible with Symfony-native frontend tooling.

### Turbo-Driven UX

MinSpec favors Turbo-driven web applications where possible.

The basic interaction model is:

> **Turbo handles immediate request/response UX. Mercure handles deferred real-time state propagation.**

That means applications can feel responsive without defaulting to unnecessary frontend complexity.

### AI-Aware, Not AI-Led

MinSpec assumes developers will increasingly work with AI assistants.

The project’s response is not to let AI freely mutate applications.

Instead:

> **AI reasons. MinSpec commands mutate.**

MinSpec AI/Mate tooling should help assistants understand the project, inspect the application, explain architecture, suggest safe commands, and validate package shape.

Freeform code generation should not become the default architecture strategy.

### Doctrine Propagation

MinSpec Mate tooling is not only about maintainer productivity.

It is also about giving AI assistants a bounded, vendor-neutral doctrine surface:

- terminology
- package taxonomy
- bundle vs recipe guidance
- architecture checks
- redirection tables
- install-state inspection
- safe command suggestions
- package-shape validation

This helps AI tools work inside MinSpec constraints instead of inventing their own architecture.

---

## Planned Build Order

The current planned development order is:

1. `workbench`
2. `ai-mate-extension` baseline
3. `ui-bundle` / MinSpec UI layer baseline
4. `dashboard-bundle` first usable version
5. Hermes Agent sandbox experiment
6. recipe ownership metadata
7. richer Mate tools
8. optional `mate-observer` later

This order is intentional.

The workbench comes first after the functional foundation because MinSpec needs a real maintainer host application where packages, recipes, Mate tools, UI layers, and dashboard surfaces can be developed and tested together.

---

## Workbench

`workbench` is the planned maintainer-only Symfony application used to develop and validate MinSpec packages.

It is not the user-facing skeleton.

It is not the product template.

It is the proving ground.

The workbench should be used to:

- install MinSpec packages locally
- validate bundle behavior
- test Flex recipe assumptions
- inspect services, routes, events, assets, and configuration
- develop Mate/MCP tooling
- test dashboard and UI package behavior
- prove package boundaries before recommending them publicly

The skeleton is what users start with.

The workbench is where maintainers prove the system.

---

## AI/Mate Tooling

MinSpec AI/Mate tooling is intended to be vendor-neutral.

Core documentation should not assume one AI assistant, one model, or one client. Developers may use ChatGPT, Claude, Gemini, Codex, local models, IDE tools, MCP clients, or other systems.

The planned `ai-mate-extension` package should provide MinSpec-specific guidance and tools without making any single AI vendor part of the architecture.

Vendor-specific adapters may exist separately, but they should not define MinSpec itself.

---

## UI Direction

The MinSpec UI direction is centered on `ui-bundle`.

The MinSpec UI layer is the reusable UI foundation behind the install surface.

The preferred package/repository term is:

> `minspec/ui-bundle`

The UI layer should support modern Symfony UX conventions, including:

- AssetMapper
- Stimulus controllers
- Turbo defaults
- Live Components
- Tailwind-friendly styling
- optional UI presets or adapters
- Mercure-ready async UX patterns

The UI layer should remain Symfony-native and package-driven.

---

## Skeleton Direction

The MinSpec skeleton should stay intentionally small.

It should provide a clean application shell and a memorable first-run experience, not a large prebuilt application.

The default homepage should act as a MinSpec orientation surface:

> **Welcome to the shell. Now compose the application.**

The core model is:

> **Shell → Capability → Wiring → Ownership → Product**

The skeleton should guide developers toward installing the capability that owns the concern, rather than encouraging copy-paste application growth.

---

## Research and Model Development

MinSpec may also include dataset and model work aimed at improving AI-assisted Symfony development.

This research track is experimental and should support the broader doctrine of the project, not replace it.

Useful outputs may include:

- Symfony-focused datasets
- doctrine snapshots
- architecture examples
- package-shape examples
- AI assistant evaluation data
- LoRA or model experiments
- repeatable snapshot formats

Fine-tuned or open-weight models may become useful downstream, but they are not an early dependency of the project.

The first priority is human-readable doctrine, package boundaries, recipes, Mate tools, and repeatable architecture.

Related research space:

- [`minspec`](https://huggingface.co/minspec) — planned Symfony-focused datasets and model experiments

If that Hugging Face organization has not yet been created, keep this link under review.

---

## What Comes Next

MinSpec is expected to grow carefully into a broader package ecosystem around:

- canonical skeleton setup
- package and bundle conventions
- Flex recipe automation
- recipe ownership metadata
- UI bundle and MinSpec UI primitives
- dashboard surfaces
- standards and validation tooling
- MinSpec Mate/MCP tools
- deterministic generators
- architecture inspection tools
- optional sandboxed agent experiments

The goal is not to expand quickly for appearances.

The goal is to expand from a foundation that is structurally sound.

---

## Project Posture

MinSpec is early.

Use it with that understanding.

The current work is about establishing the foundation, proving the package model, and documenting the architectural doctrine before encouraging broad adoption.

MinSpec should earn trust by being:

- clear
- practical
- inspectable
- Symfony-native
- package-driven
- honest about status
- careful with automation
- respectful of the Symfony ecosystem

---

## Start Here

To understand the direction of MinSpec, begin with the documentation in [`.github`](https://github.com/minspec/.github).

That repository defines the architecture, terminology, constraints, governance, and planning principles guiding the next phase of the organization.

Suggested reading order:

1. organization profile
2. architecture overview
3. terminology
4. package guidelines
5. repository taxonomy
6. command and generation model
7. AI/Mate strategy
8. governance and contribution guidance

---

## Follow the Project

MinSpec is still early, but this is the stage where the direction is being established.

If the vision resonates with you:

- **Star the repositories**
- **Follow the organization**
- **Check back soon**

The foundation is being built now.

The ecosystem comes next.
