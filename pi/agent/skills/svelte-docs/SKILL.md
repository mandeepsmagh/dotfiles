---
name: svelte-docs
description: Comprehensive tool to interact with Svelte documentation and development utilities using the global svelte-docs binary. Supports fetching documentation, listing sections, auto-fixing code, and generating playground links.
---

# Svelte Docs & Development Utilities

Use when the user is asking for information, code examples, or assistance with Svelte development in general. This tool encapsulates all functionalities of the `svelte-docs` binary.

## 📚 Fetching Documentation (The Recommended Workflow)
**ALWAYS** start by calling `list-sections` to understand what documentation is available before attempting to fetch specific content.

### 1. List Available Sections (The Discovery Phase)
Use this first to get a map of all available topics and their intended use cases.
`svelte-docs list-sections`

**CRITICAL STEP:** After receiving the output, carefully analyze the `use_cases` field for each section. Match these keywords (e.g., "e-commerce", "forms", "authentication", "typescript") against the user's original query.

### 2. Get Specific Documentation (The Retrieval Phase)
Use this to retrieve the content for the most relevant sections identified in Step 1. You can pass multiple relevant section titles/paths to fetch related concepts at once.
`svelte-docs get-documentation --section <section_name_or_path_1> --section <section_name_or_path_2> ...`

*Example Workflow:*
1.  Run `svelte-docs list-sections`.
2.  Analyze output and find sections matching "authentication" and "forms".
3.  Run `svelte-docs get-documentation --section "kit/auth" --section "kit/form-actions"`.

## 🛠️ Code Assistance
Use these commands when the user is actively writing or debugging Svelte code.

### 1. Auto-Fix Code
When the user provides a Svelte component/module that needs review or fixing.
`svelte-docs svelte-autofixer --code <code_snippet> [--desired-svelte-version <version>] [--filename <filename>]`

### 2. Generate Playground Link
When the user has a final piece of code and wants a shareable link to test it.
`svelte-docs playground-link --name <name> --tailwind <tailwind:true|false> --files <files:json>`

## 🚀 Quick Reference & Other
### Search (Simple Query)
For quick, general queries when the workflow is too complex, use the search command.
`svelte-docs search "<natural language query>"`

### General Workflow Guidance
1.  **Documentation Query:** $\\rightarrow$ `list-sections` $\\rightarrow$ (Analyze) $\\rightarrow$ `get-documentation`
2.  **Code Review:** $\\rightarrow$ `svelte-autofixer`
3.  **Share Code:** $\\rightarrow$ `playground-link`