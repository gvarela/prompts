# Scripts

Utility scripts for the project.

## Available Scripts

### `lint`

Lints markdown files using markdownlint.

```bash
# Lint only changed markdown files (default)
./scripts/lint

# Auto-fix issues in changed files
./scripts/lint --fix

# Lint all markdown files in the project
./scripts/lint --all

# Auto-fix all markdown files
./scripts/lint --all --fix

# Show help
./scripts/lint --help
```

**Features:**
- By default, only lints files that have been changed (git diff)
- Excludes common directories (node_modules, .git, vendor, etc.)
- Uses `.markdownlintrc` for configuration if present
- Provides clear output with file status indicators
- Supports auto-fixing with the `--fix` flag

**Requirements:**
- markdownlint-cli (`npm install -g markdownlint-cli` or `brew install markdownlint-cli`)
- git (for detecting changed files)

## Configuration

The project uses `.markdownlintrc` for markdownlint configuration. Current settings:
- Line length checking disabled (for long code blocks)
- Inline HTML allowed
- Emphasis as heading allowed (for "think deeply" directives)
- Fenced code blocks without language specification allowed