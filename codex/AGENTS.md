# Agent Instructions

These instructions define how AI coding agents should work in this repository.

## Core Principle

Plan first, implement second.

Agents must favour short, reviewable iterations over large, unapproved changes. The goal is to help safely and predictably, not to maximise the amount of code changed.

## Language

- Use English for all agent responses, code comments, documentation, commit messages, branch names, PR descriptions, and user-facing text unless explicitly requested otherwise.
- Prefer clear, neutral, concise wording.
- Avoid slang, idioms, marketing language, and overly enthusiastic phrasing.

## Agent Workflow

For non-trivial tasks, follow this workflow:

1. Inspect the relevant files and existing patterns.
2. Summarise what you understood.
3. Propose a short plan.
4. List the files or areas likely to be changed.
5. State assumptions and open questions.
6. Wait for confirmation before making significant changes.
7. Implement the smallest useful step.
8. Verify the result where practical.
9. Summarise what changed and how it was verified.

Do not skip the planning step for architectural changes, dependency changes, schema changes, destructive operations, security-sensitive changes, or broad refactors.

## Planning and Approval

- Ask before making broad architectural, security, data model, or UX decisions.
- Ask before deleting files, changing migrations, modifying generated files, running destructive commands, or altering database/schema behaviour.
- For small low-risk details, make a reasonable assumption and state it clearly.
- Do not continue expanding the scope without approval.
- If the task is ambiguous, clarify before implementing high-impact changes.

## Codebase Awareness

- Inspect the existing code before adding new code.
- Reuse existing patterns, naming conventions, architecture, utilities, and libraries where appropriate.
- Do not introduce parallel abstractions when a suitable pattern already exists.
- Preserve existing behaviour unless the task explicitly asks to change it.
- Avoid changing public APIs unless the approved task requires it.

## Implementation Rules

- Prefer small, reviewable changes.
- Write readable, boring, maintainable code over clever or overly compact code.
- Keep changes scoped to the task.
- Do not refactor unrelated code.
- Do not rename files, move modules, or reorganise folders unless explicitly requested or approved in the plan.
- Avoid large rewrites when a focused change solves the problem.

## Code Formatting

- Follow the formatter, linter, and style conventions already configured in the repository.
- Do not introduce a new formatter, linter, or style guide unless explicitly requested.
- Preserve existing formatting in untouched code.
- Avoid formatting-only diffs unless formatting is the explicit task.
- Use meaningful names and avoid vague names like `data`, `item`, `helper`, or `manager` unless they match existing project conventions.

## Documentation Style

- Use clear Markdown with meaningful headings.
- Prefer short paragraphs and concise bullet points.
- Use fenced code blocks with language identifiers.
- Use relative links for repository files where possible.
- Keep examples minimal but runnable when practical.
- Update relevant documentation when behaviour, setup, commands, or public APIs change.

## Locale and Formatting

- Use European formatting by default where applicable.
- Use ISO dates: `YYYY-MM-DD`, for example `2026-06-13`.
- Use 24-hour time: `14:30`, not `2:30 PM`.
- Use metric units by default: `mm`, `cm`, `m`, `km`, `g`, `kg`, `°C`.
- Use EUR (`€`) as the default currency unless the project requires another currency.
- Do not assume US-specific formats, laws, addresses, tax rules, phone formats, or payment methods.

## Testing and Verification

- After changes, explain how they were verified.
- Prefer running existing tests, type checks, linters, or build commands when relevant.
- If verification cannot be run, clearly state why and describe the expected validation steps.
- Do not claim that tests passed unless they were actually run.
- If a change is risky, suggest a rollback or validation strategy.

## Dependencies

- Do not add new dependencies unless necessary.
- Before adding a dependency, explain why it is needed and whether existing project tools can solve the problem.
- Prefer stable, well-maintained, commonly used dependencies.
- Avoid introducing large dependencies for small problems.

## Security and Secrets

- Never expose, log, modify, invent, or commit secrets, tokens, credentials, private keys, or environment values.
- Use placeholders for secrets and document required environment variables.
- Avoid unsafe shell commands unless they are explicitly required and approved.
- Be careful with user data, authentication, authorisation, payments, and database changes.

## Git Behaviour

- Do not create commits, branches, tags, or push changes unless explicitly asked.
- Do not rewrite git history unless explicitly asked and the risks are explained.
- Do not push to remote repositories unless explicitly asked.
- When summarising changes, group them by purpose rather than listing every edited line.

## Final Response Format

After making changes, respond with:

- a concise summary of what changed,
- verification performed,
- files changed,
- any remaining risks, assumptions, or recommended next steps.
