# MinSpec Package Naming

This document defines the naming conventions for MinSpec repositories and packages.

MinSpec is an independent community project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

---

## Core Rules

### 1. Use Responsibility-Based Names

A package name should describe what a developer installs, not the internal mechanism used to implement it.

Good:

- `ui-bundle`
- `dashboard-bundle`
- `ai-mate-extension`
- `standards`

Bad unless the boundary is proven:

- `runtime`
- `core`
- `kernel`
- `contracts`
- `mcp`
- `maker`

### 2. One Primary Installable Package Per Repository

MinSpec defaults to one primary package per repository unless there is a strong reason to do otherwise.

### 3. Repo Name Should Match Package Name Segment

If the Composer package is:

- `minspec/ui-bundle`

then the repository should be:

- `minspec/ui-bundle`

### 4. Reserve Abstract Names

Do not create abstract top-level names until the boundary is proven in practice.

Reserved / deferred examples:

- `core`
- `runtime`
- `kernel`
- `contracts`
- `buffer`
- `maker`
- `mcp`

### 5. Avoid Official-Sounding Claims

Package names and descriptions must not imply that MinSpec is official Symfony, a Symfony distribution, a certification authority, or a replacement for Symfony.

MinSpec packages are independent packages built for Symfony applications.

---

## Package Type Naming

### Project Shell

Use a simple, direct name.

Example:

- `minspec/skeleton`

### Maintainer Workbench

Use a simple, direct name.

Example:

- `minspec/workbench`

The workbench is a maintainer host application, not a reusable package.

### Reusable Symfony Bundles

Suffix reusable Symfony feature packages with:

- `-bundle`

Examples:

- `minspec/ui-bundle`
- `minspec/dashboard-bundle`
- `minspec/api-bundle`
- `minspec/user-bundle`

### UX-Oriented Symfony Bundles

Use `-bundle` naming, not vague frontend package naming.

Preferred:

- `minspec/ui-bundle`

Avoid:

- `minspec/ui-component`
- `minspec/components`
- `minspec/frontend`

### AI/Mate Packages

Suffix MinSpec Mate extension packages with:

- `-mate-extension`

Examples:

- `minspec/ai-mate-extension`

Future specialized extensions should follow the same pattern unless there is a compelling reason not to.

### Optional Vendor Adapters

Vendor-specific adapters may use names that make the adapter role explicit.

They must not imply that the vendor is required by MinSpec core architecture.

### Standards / Tooling Packages

Use a direct responsibility-based name.

Examples:

- `minspec/standards`

---

## Naming Doctrine

MinSpec should prefer names that are:

- explicit
- stable
- Symfony-native
- Composer-aligned
- ecosystem-aligned
- install-surface oriented

MinSpec should avoid names that are:

- overly theoretical
- protocol-centric without need
- likely to collide conceptually with official Symfony packages
- unclear to developers browsing the org
- suggestive of official Symfony status

---

## MinSpec Terminology vs Package Naming

Not every strong architecture term should become a repo name.

Example:

- **MinSpec UI layer** is a useful architecture term.
- **ui-bundle** is the preferred install/package name.

Likewise:

- **Identity** is a strong architecture term.
- It should not automatically become the package name for auth/user code.

---

## Composer Naming Expectations

Composer package names should remain lowercase and follow the conventional `vendor/package` form.

MinSpec vendor:

- `minspec`

Package segment:

- lowercase
- hyphenated where needed
- responsibility based

---

## Current Functional Names

- `minspec/.github` — organization doctrine, architecture, governance, terminology, and planning
- `minspec/skeleton` — project shell for new applications

---

## Current Planned Names

- `minspec/workbench` — maintainer validation host; not a package
- `minspec/recipes` — recipes infrastructure
- `minspec/ui-bundle` — reusable Symfony UX-oriented bundle
- `minspec/ai-mate-extension` — vendor-neutral Mate/MCP extension
- `minspec/standards` — standards/tooling
- `minspec/dashboard-bundle` — reusable operational UI surface

---

## Approved Deferred Names

- `minspec/api-bundle`
- `minspec/user-bundle`
- `minspec/user-oauth-bundle`
- `minspec/agent-runtime-bundle`
- `minspec/mate-observer`

---

## Avoided Public Language

Avoid package descriptions using:

- official Symfony
- certified MinSpec
- Symfony distribution
- Symfony replacement
- next Symfony
- autonomous AI generator
- software factory

Prefer:

- independent Symfony ecosystem project
- built for Symfony applications
- Symfony-native package composition
- package-first architecture
- Turbo-driven web applications
- AI/Mate developer assistance
