# MinSpec AI Strategy

## Position

MinSpec AI/Mate strategy is about bounded developer assistance, doctrine propagation, and application inspection.

It is not about allowing AI to freely mutate Symfony applications.

Core rule:

> **AI reasons. MinSpec commands mutate.**

MinSpec is an independent community project built for Symfony applications. It is not affiliated with, endorsed by, sponsored by, or maintained by Symfony SAS or the Symfony project. Symfony is a trademark of Symfony SAS.

---

## Current Direction

MinSpec uses AI/Mate tooling as the primary development-time AI integration surface.

This is a deliberate shift away from centering AI-assisted development around freeform code generation or custom scaffolding alone.

Maker-style generators may still exist for normal developer ergonomics where useful, but they are not the governing AI strategy.

---

## Vendor-Neutral Posture

MinSpec core documentation and tooling should not privilege any single AI client, vendor, model, or IDE.

Use vendor-neutral terms such as:

- AI assistant
- AI model
- MCP client
- Mate-compatible client
- developer's AI environment

Avoid making any of these the default or privileged architecture:

- Claude
- ChatGPT
- Gemini
- Codex
- Copilot
- local models
- any specific commercial provider

Vendor-specific adapters may exist separately, but they must not define MinSpec itself.

---

## Development-Time AI

Development-time AI is about helping a developer work on the codebase locally.

In MinSpec, this should be handled through:

- MinSpec Mate/MCP tools
- MinSpec doctrine resources
- package taxonomy guidance
- tool/resource/prompt-based assistance
- instruction files and explicit repository context
- standards and validation to constrain drift
- safe command suggestions rather than direct uncontrolled mutation

---

## What This Replaces

MinSpec no longer treats freeform AI scaffolding as the main control surface.

It also does not require a custom Maker-based strategy to be the center of the AI model.

Maker may still be useful, but MinSpec should prefer explicit, bounded, auditable commands and tools.

---

## Development-Time Goals

Development-time AI in MinSpec should:

- understand the codebase and package boundaries
- follow MinSpec terminology and naming rules
- distinguish package, bundle, recipe, component, skeleton, and workbench
- prefer recipes and existing install surfaces over improvised structure
- inspect the application's declared and actual state
- explain behavior in Symfony-native terms
- reduce architectural drift
- help developers work faster without bypassing constraints

---

## Doctrine Propagation

MinSpec AI/Mate tooling is not only about maintainer productivity.

It should expose a bounded doctrine surface that helps AI assistants understand MinSpec before generating suggestions.

The doctrine surface should include:

- terminology
- package taxonomy
- bundle vs recipe vs app/workbench guidance
- redirection tables
- architecture audit prompts
- package-shape validation
- install-state inspection
- safe command suggestions

This helps AI assistants work inside MinSpec constraints instead of inventing their own architecture.

---

## Tool Taxonomy

MinSpec should favor tools that expose application truth in Symfony-native terms.

Recommended prefixes:

- `inspect_*` for coherent snapshots
- `why_*` for behavior explanations
- `truth_*` for declared-vs-actual checks
- `graph_*` for dependencies, listeners, routes, services, and ownership
- `replay_*` for safe dev/test replays
- `simulate_*` for hypothetical non-persistent behavior

Good tools should explain behavior, not just dump implementation trivia.

---

## Repository Implications

### `minspec/ai-mate-extension`

This repository is the primary planned home for MinSpec doctrine/package/recipe/architecture tools.

It should contain MinSpec-specific:

- Mate tools
- MCP resources
- prompts
- instructions
- local development guidance
- architecture-aware assistance surfaces
- terminology and redirection tables
- package-shape validators

### `minspec/workbench`

This repository is the planned maintainer-only Mate-enabled host application.

It is the primary planned working environment for MinSpec contributors and the expected context for MinSpec-specific Mate tooling.

It is also the integration host where contributors validate that MinSpec packages and recipes install and wire correctly inside a real Symfony application.

### Optional Vendor Adapters

Optional vendor adapters may provide client-specific setup files, prompts, config examples, and usage guidance.

Examples may include adapters for a particular MCP client or AI assistant.

These adapters must not define MinSpec architecture and must not be required by the workbench.

### Runtime AI Packages

Runtime AI is separate from development-time AI/Mate tooling.

Runtime AI package boundaries should be deferred until MinSpec has a clearly defined reusable runtime AI layer.

---

## Runtime AI

Runtime AI includes AI behavior that executes inside the running application itself, such as:

- agent workflows
- chat interfaces
- runtime tools
- provider integration
- application-level AI orchestration

MinSpec should treat runtime AI as its own package concern and not blur it with development-time tooling.

---

## Sandboxed Agent Experiments

External agent runtimes may be explored only as sandboxed experiments.

The Hermes Agent experiment is planned after the first dashboard work.

Hermes should be treated as an external experimental scout/runtime, not MinSpec architecture.

Security posture:

- Docker sandbox required
- restricted egress
- no raw host access
- no production secrets
- no writable access to real MinSpec repos by default
- integration through MinSpec Mate/MCP tools in workbench

Useful workflows may later be promoted into deterministic MinSpec Mate tools or a future observer package.

---

## Doctrine

MinSpec AI doctrine is:

- Mate/MCP for development-time AI
- recipes for deterministic install-time wiring
- commands for bounded mutation
- standards for validation and consistency
- runtime AI treated separately from development tooling
- human-readable Markdown doctrine remains load-bearing

---

## Guardrails

AI usage in MinSpec should never become a justification for:

- uncontrolled repository sprawl
- freeform architectural invention
- bypassing package boundaries
- hiding complexity inside vague abstractions
- host-level trusted agent operation
- silent mutation of user applications
- vendor lock-in disguised as architecture

AI should accelerate work inside the architecture, not dissolve the architecture.
