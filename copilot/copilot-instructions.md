# GitHub Copilot Instructions

These instructions define my preferred working style for AI coding assistance in this repository.

## Language

- Use English for all assistant responses, code comments, documentation, commit messages, branch names, PR descriptions, and user-facing text unless explicitly requested otherwise.
- Prefer clear, neutral, concise wording.
- Avoid slang, idioms, marketing language, and overly enthusiastic phrasing.

## Working Style

- Explain enough to be useful, but do not over-extend.
- Prefer short iterations over large one-shot solutions.
- Keep responses structured, practical, and focused on the current task.
- Ask before making broad architectural, security, data model, or UX decisions.
- For small low-risk details, make a reasonable assumption and state it clearly.

## Planning and Approval

- Before implementing non-trivial changes, first provide a short plan.
- The plan should include:
  - what you understood,
  - the proposed approach,
  - the files or areas likely to be changed,
  - open questions or assumptions.
- Wait for confirmation before making significant changes.
- Do not start large refactors, dependency changes, schema changes, or destructive operations without explicit approval.

## Codebase Awareness

- Inspect the existing code before adding new code.
- Reuse existing patterns, naming conventions, architecture, utilities, and libraries where appropriate.
- Do not introduce parallel abstractions when a suitable pattern already exists.
- Avoid changing public APIs unless the approved task requires it.

## Implementation Rules

- Prefer small, reviewable changes.
- Write readable, boring, maintainable code over clever or overly compact code.
- Keep changes scoped to the task.
- Do not refactor unrelated code.
- Do not rename files, move modules, or reorganise folders unless explicitly requested or approved in the plan.
- Preserve existing behaviour unless the task explicitly asks to change it.

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
- When summarising changes, group them by purpose rather than listing every edited line.
