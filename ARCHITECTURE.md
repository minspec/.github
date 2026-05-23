# MinSpec Architecture

## Position

MinSpec is a constraint-driven, package-first architecture project for building modern Symfony applications with a small, explicit, reusable package graph.

It is designed to reduce architectural drift, keep installation deterministic, and make AI-assisted development work within defined Symfony-native boundaries.

MinSpec is an independent community project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

---

## Architectural Premise

MinSpec starts from this rule:

> **Start by installing the capability that owns the concern.**

Reusable behavior should enter an application through a package whenever possible.

If runtime Symfony integration is needed, the package should usually be a Symfony bundle.

If setup or wiring is needed, it should be automated through a Flex recipe.

If files must be generated into the host application, that generation should be explicit, deterministic, minimal, and reviewable.

---

## Core Principles

### 1. One Canonical Skeleton

MinSpec starts from one canonical application skeleton.

The skeleton defines the baseline project shape and first-run developer experience, but it is intentionally minimal. It should not assume every application needs the same feature set.

The skeleton is not a full distribution, product template, or demonstration application.

It is the shell.

### 2. Composition Over Monoliths

Applications are assembled by installing focused packages rather than growing one large framework layer.

MinSpec favors:

- one project shell
- installable packages for reusable capabilities
- Symfony bundles for runtime integration
- Flex recipes for deterministic wiring
- standards/tooling for consistency
- explicit package boundaries

### 3. Package-First Responsibility

A MinSpec package should own a clear concern.

The application should not accumulate reusable behavior as project-local code when that behavior belongs in a package.

The package owns the capability. The recipe wires it. The application composes it.

### 4. Deterministic Installation

Installation should be reproducible.

That means:

- package boundaries should be clear
- recipes should apply predictable configuration
- optional features should remain optional
- generated files should be minimal and reviewable
- defaults should reduce ambiguity instead of increasing it

### 5. LAST-First UI Doctrine

MinSpec treats the LAST stack as the default UI posture for modern Symfony applications:

- **L**ive Components
- **A**ssetMapper
- **S**timulus
- **T**urbo

This is the default direction for interactive web applications, especially inside the MinSpec UI layer.

### 6. Async UX by Design

For interactive MinSpec web applications:

- Turbo governs the immediate request-response cycle
- Mercure governs deferred real-time state propagation back into the UI
- Messenger governs asynchronous work execution

This split is the preferred default for responsive, async-first user experience.

### 7. AI Within Defined Boundaries

MinSpec treats AI/Mate tooling as a development-time assistance surface, not as an excuse for unconstrained application mutation.

Core doctrine:

> **AI reasons. MinSpec commands mutate.**

That means:

- Mate extensions provide tools, resources, prompts, and instructions
- commands provide bounded mutation surfaces
- recipes provide deterministic installation and wiring
- standards and validation protect architectural consistency
- runtime AI remains separate from development-time AI tooling

---

## System Model

MinSpec thinks about application composition through five architectural stages:

> **Shell → Capability → Wiring → Ownership → Product**

### Shell

The application starts as a small, intentional MinSpec skeleton.

### Capability

A package introduces a reusable concern.

### Wiring

A Flex recipe or explicit command connects the capability to the host application.

### Ownership

The installed package owns the reusable behavior. The host application owns product-specific decisions.

### Product

The application grows by composing capabilities intentionally, not by accumulating unclear local structure.

---

## Architectural Lenses

MinSpec also describes applications through three lenses.

### Identity

What the application is.

This includes the chosen application posture and install surface, not user authentication concerns.

### Capabilities

What the application can do.

Capabilities are installed through packages and enabled through explicit composition.

### Application Structure

How the application is experienced.

This includes web UI, API surfaces, operational dashboards, and other delivery shapes.

---

## Package Model

MinSpec recognizes several package and repository types.

### Project Shell

A canonical application shell.

Example:

- `minspec/skeleton`

### Maintainer Workbench

A maintainer-only Symfony application used to validate packages, recipes, and Mate tooling in a real host application.

Example:

- `minspec/workbench`

### Bundle

A reusable Symfony package intended for installation across multiple applications when runtime Symfony integration is needed.

Examples:

- `minspec/ui-bundle`
- `minspec/dashboard-bundle`
- `minspec/api-bundle`

### UX Bundle

A Symfony bundle that ships frontend assets, controllers, or UI behavior in the Symfony UX style.

The MinSpec UI bundle should be treated as a UX-oriented Symfony bundle.

### Mate Extension

A Composer package that provides MinSpec-specific development-time AI/Mate tooling.

Example:

- `minspec/ai-mate-extension`

### Standards / Tooling Package

A reusable package for coding standards, analysis rules, CI conventions, and related enforcement.

Example:

- `minspec/standards`

### Recipes Repository

A dedicated repository for Symfony Flex recipes.

Recipes provide the installation and wiring contract for packages.

They are not the capability itself; the capability lives in the package.

Example:

- `minspec/recipes`

---

## MinSpec UI Direction

The MinSpec UI direction is centered on `ui-bundle`.

The MinSpec UI layer is the reusable UI foundation behind the install surface:

- `minspec/ui-bundle`

The UI layer should remain Symfony-native and support:

- AssetMapper
- Stimulus controllers
- Turbo defaults
- Live Components
- Tailwind-friendly styling
- optional UI presets or adapters
- Mercure-ready async UX patterns

---

## Workbench Direction

`workbench` is the maintainer-only host application.

It exists to prove the package-and-recipe path inside a real Symfony environment.

It should be used to:

- install MinSpec packages locally
- validate bundle behavior
- test Flex recipe assumptions
- inspect Symfony services, routes, events, assets, and configuration
- develop AI/Mate tools
- test dashboard and UI package behavior
- prove package boundaries before recommending them publicly

Reusable behavior that originates in the workbench should be extracted into a package when the boundary becomes clear.

---

## Non-Goals

MinSpec does not aim to be:

- official Symfony
- a Symfony replacement
- a fork of Symfony
- a certification authority
- an everything-in-one monolith
- a speculative package explosion
- a parallel reinvention of Symfony's own naming
- an excuse for unconstrained AI code generation
- an autonomous AI app generator

---

## Current Architectural Direction

The organization reset is intentionally conservative.

The currently functional repositories are:

- `minspec/.github`
- `minspec/skeleton`

The current planned development order is:

1. `workbench`
2. `ai-mate-extension` baseline
3. `ui-bundle` / MinSpec UI layer baseline
4. `dashboard-bundle` first usable version
5. Hermes Agent sandbox experiment
6. recipe ownership metadata
7. richer Mate tools
8. optional `mate-observer` later

Additional packages should be created only after their boundaries are proven by actual use.

New reusable behavior should enter the ecosystem through a package, be wired through a recipe, and be validated inside a real Symfony host application before wider adoption.

`workbench` serves as that host once it exists.
