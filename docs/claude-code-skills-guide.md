# Claude Code Skills - Complete Guide

This guide documents everything you need to know about creating and using Claude Code Skills based on official documentation research.

## Table of Contents

- [What are Skills?](#what-are-skills)
- [Skills vs Slash Commands](#skills-vs-slash-commands)
- [File Structure](#file-structure)
- [Creating a Skill](#creating-a-skill)
- [SKILL.md Format](#skillmd-format)
- [Best Practices](#best-practices)
- [Examples](#examples)
- [When to Use Skills](#when-to-use-skills)
- [Limitations and Considerations](#limitations-and-considerations)

---

## What are Skills?

**Claude Code Skills** are modular capabilities that package expertise into discoverable, organized folders containing instructions, scripts, and resources. They represent reusable functionality that extends Claude Code's capabilities.

**Key Characteristics:**

- **Model-invoked**: Claude autonomously decides when to use them
- **Context-aware**: Activated based on user request context and skill descriptions
- **Discovery-based**: No explicit invocation syntax required
- **Modular**: Each skill is self-contained in its own directory

---

## Skills vs Slash Commands

Understanding when to use skills versus slash commands is critical:

| Aspect | Slash Commands | Skills |
|--------|---------------|--------|
| **Invocation** | User types `/command` | Claude invokes automatically |
| **Discovery** | User must know command name | Claude discovers from description |
| **Control** | Explicit user control | Claude decides when relevant |
| **Location** | `~/.claude/commands/` or `.claude/commands/` | `~/.claude/skills/` or `.claude/skills/` |
| **File Format** | Single `.md` file | Directory with `SKILL.md` + supporting files |
| **Organization** | Subdirectories create prefixes (`/wb:name`) | Flat structure, one directory per skill |
| **Use Case** | Explicit workflow steps | Background capabilities |

**Example Comparison:**

- **Slash Command**: `/wb:create_project` - User explicitly starts project creation
- **Skill**: User says "I need to start a new feature" → Claude automatically invokes project-creation skill

---

## File Structure

### Installation Locations

Skills can be installed in three locations:

```
~/.claude/skills/          # Personal skills (individual use)
.claude/skills/            # Project skills (team-shared via git)
plugins/*/skills/          # Plugin skills (distributed with plugins)
```

### Directory Structure

Each skill lives in its own directory:

```
.claude/skills/
├── skill-one/
│   └── SKILL.md           # Required: Core skill definition
├── skill-two/
│   ├── SKILL.md           # Required: Core skill definition
│   ├── script.sh          # Optional: Supporting script
│   └── templates/         # Optional: Supporting files
│       └── template.md
└── skill-three/
    ├── SKILL.md
    ├── analyzer.sh
    └── docs/
        └── usage-guide.md
```

**Important Notes:**

- **No subdirectory prefixes**: Unlike slash commands, skills use a flat structure
- **One directory per skill**: Each skill gets its own folder
- **SKILL.md is required**: This is the entry point for the skill
- **Supporting files optional**: Include scripts, templates, or documentation as needed

---

## Creating a Skill

### Step 1: Choose Scope

Decide where to create your skill:

```bash
# Personal skill (only you)
mkdir -p ~/.claude/skills/my-skill

# Project skill (entire team via git)
mkdir -p .claude/skills/my-skill
```

### Step 2: Create SKILL.md

Create the core skill definition file:

```bash
# Personal skill
touch ~/.claude/skills/my-skill/SKILL.md

# Project skill
touch .claude/skills/my-skill/SKILL.md
```

### Step 3: Define Skill Content

Edit `SKILL.md` with frontmatter and instructions (see format below).

### Step 4: Add Supporting Files (Optional)

Add any scripts, templates, or documentation:

```bash
# Example supporting files
.claude/skills/my-skill/
├── SKILL.md
├── helper-script.sh
├── templates/
│   └── output-template.md
└── docs/
    └── detailed-guide.md
```

### Step 5: Test Activation

Ask Claude questions that should trigger your skill:

```
User: "Can you help me with [skill purpose]?"
Claude: [Should invoke skill automatically]
```

---

## SKILL.md Format

Skills use YAML frontmatter followed by optional markdown content:

```markdown
---
name: skill-name-here
description: Clear description of what the skill does and when to use it. Include trigger terms users might mention.
allowed-tools:           # Optional, Claude Code only
  - Read
  - Write
  - Bash
---

# Skill Title

Optional markdown content with:
- Instructions for Claude to follow
- Examples and usage patterns
- Supporting documentation
- References to supporting files
```

### Frontmatter Fields

#### `name` (required)

- **Type**: string
- **Max Length**: 64 characters
- **Format**: lowercase letters, numbers, hyphens only
- **Examples**:
  - ✅ `code-analyzer`
  - ✅ `test-generator`
  - ✅ `tdd-workflow`
  - ❌ `CodeAnalyzer` (no PascalCase)
  - ❌ `code_analyzer` (use hyphens, not underscores)
  - ❌ `analyze` (too generic)

#### `description` (required)

- **Type**: string
- **Max Length**: 1024 characters
- **Purpose**: Explains what the skill does and when Claude should use it
- **Best Practices**:
  - Include trigger terms users might mention
  - Describe the context where skill is useful
  - Be specific about capabilities
  - Think "What would a user say to need this?"

**Good Description Examples:**

```yaml
description: Analyzes code structure and complexity. Use when users ask about code quality, patterns, or need analysis reports.
```

```yaml
description: Guides Test-Driven Development following Red-Green-Refactor cycle. Use when implementing features with TDD or when user mentions writing tests first.
```

**Bad Description Examples:**

```yaml
description: Helps with code.  # Too vague
```

```yaml
description: Use this skill.  # Doesn't explain when or why
```

#### `allowed-tools` (optional)

- **Type**: array of strings
- **Purpose**: Restricts which tools the skill can invoke (security feature)
- **Availability**: Claude Code only (not other Claude interfaces)
- **Usage**: Whitelist specific tools

**Example:**

```yaml
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
```

**Security Consideration**: Use this to prevent accidental or malicious use of dangerous operations in team-shared project skills.

### Content Section

After the frontmatter, include markdown instructions:

```markdown
# Skill Title

Brief description of what this skill does.

## What It Does

- Capability 1
- Capability 2
- Capability 3

## When to Use

Activate this skill when users:
- Mention [trigger phrase 1]
- Ask about [topic]
- Need to [action]

## Instructions

Step-by-step instructions for Claude to follow when this skill is activated.

## Examples

Example requests that should trigger this skill:
- "Can you [action]?"
- "I need help with [topic]"
```

---

## Best Practices

### Naming Conventions

1. **Use lowercase with hyphens**: `code-analyzer`, not `CodeAnalyzer` or `code_analyzer`
2. **Be specific**: `tdd-workflow` is better than `test`
3. **Use descriptive names**: Name should hint at purpose
4. **Keep it short**: Max 64 characters, but shorter is better
5. **Avoid generic names**: `analyze-code` not `tool` or `helper`

### Description Writing

1. **Include trigger terms**: Words users might say when they need the skill
2. **Be specific about context**: When should Claude invoke this?
3. **Describe capabilities clearly**: What can this skill do?
4. **Think like a user**: What would someone ask to need this?
5. **Test with variations**: Try different phrasings to ensure activation

**Example - Good Description:**

```yaml
description: Implements Test-Driven Development (TDD) workflow following Kent Beck's Red-Green-Refactor cycle. Use when user wants to implement features test-first, mentions TDD, or asks to write tests before code.
```

This includes:

- Clear purpose (TDD workflow)
- Methodology reference (Red-Green-Refactor)
- Trigger terms (test-first, TDD, tests before code)
- Context (implementing features)

### Skill Organization

1. **One skill, one responsibility**: Keep skills focused
2. **Use supporting files**: Don't cram everything into SKILL.md
3. **Document dependencies**: Note any required scripts or tools
4. **Version your skills**: Track changes in git for project skills
5. **Test thoroughly**: Verify activation with various phrasings

### Tool Restrictions

1. **Use `allowed-tools` for shared skills**: Prevent accidental damage
2. **Whitelist only necessary tools**: Principle of least privilege
3. **Document tool usage**: Explain why each tool is needed
4. **Test with restrictions**: Ensure skill works with limited tools

---

## Examples

### Example 1: TDD Workflow Skill

**Directory Structure:**

```
.claude/skills/tdd-workflow/
└── SKILL.md
```

**SKILL.md:**

```markdown
---
name: tdd-workflow
description: Implements Test-Driven Development (TDD) workflow following Kent Beck's Red-Green-Refactor cycle. Use when user wants to implement features test-first, mentions TDD, or asks to write tests before code.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

# TDD Workflow Skill

This skill guides Test-Driven Development following the Red-Green-Refactor cycle.

## What It Does

- Guides writing failing tests first (Red)
- Implements minimum code to pass tests (Green)
- Refactors code while tests pass (Refactor)
- Enforces TDD discipline and best practices

## When to Use

Activate when users:
- Request TDD implementation
- Ask to write tests first
- Mention Red-Green-Refactor
- Want to implement a feature test-first
- Say "let's do TDD"

## TDD Cycle Instructions

### Phase 1: Red (Failing Test)

1. Write a single failing test for next small increment
2. Test should be specific and focused
3. Run test to confirm it fails
4. Do not proceed until test fails correctly

### Phase 2: Green (Make it Pass)

1. Write minimum code to make test pass
2. No more, no less
3. Avoid over-engineering
4. Run test to confirm it passes

### Phase 3: Refactor (Clean Up)

1. Clean up code while tests pass
2. Remove duplication
3. Improve naming and structure
4. Run tests after each refactoring
5. Only refactor when tests are green

### Repeat

Continue cycle for each new increment of functionality.

## Examples

User requests that should activate this skill:

- "Let's implement this feature using TDD"
- "Can you write the test first?"
- "I want to do Red-Green-Refactor"
- "Help me implement this test-first"
```

### Example 2: Code Analyzer Skill

**Directory Structure:**

```
.claude/skills/code-analyzer/
├── SKILL.md
├── analyzer.sh
├── templates/
│   └── report-template.md
└── docs/
    └── metrics-guide.md
```

**SKILL.md:**

```markdown
---
name: code-analyzer
description: Analyzes code structure, complexity, and quality metrics. Use when users ask about code quality, want to examine patterns, need complexity analysis, or request code review insights.
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
  - Glob
---

# Code Analyzer Skill

Provides comprehensive code analysis capabilities including structure, complexity, and quality metrics.

## What It Does

- Analyzes code structure and architecture
- Calculates complexity metrics
- Identifies common patterns and anti-patterns
- Generates detailed analysis reports
- Provides actionable insights

## When to Use

Activate when users:
- Ask about code quality
- Request complexity analysis
- Want to understand code structure
- Need code review insights
- Mention technical debt
- Ask "how complex is this code?"

## Analysis Process

1. **Scan codebase** using Glob to find relevant files
2. **Run analyzer.sh** script for metrics calculation
3. **Analyze patterns** using Grep for specific issues
4. **Generate report** using templates/report-template.md
5. **Provide insights** based on docs/metrics-guide.md

## Supporting Files

- `analyzer.sh`: Script that calculates complexity metrics
- `templates/report-template.md`: Template for analysis reports
- `docs/metrics-guide.md`: Reference for interpreting metrics

## Usage

When this skill activates, Claude will:
1. Identify files to analyze
2. Run analysis scripts
3. Collect metrics and findings
4. Generate formatted report
5. Provide recommendations
```

### Example 3: Documentation Generator

**Directory Structure:**

```
.claude/skills/doc-generator/
├── SKILL.md
├── generate-docs.sh
└── templates/
    ├── api-docs-template.md
    ├── component-docs-template.md
    └── readme-template.md
```

**SKILL.md:**

```markdown
---
name: doc-generator
description: Generates comprehensive documentation from code including API docs, component docs, and README files. Use when users request documentation, ask to document code, or need to create docs for features.
allowed-tools:
  - Read
  - Write
  - Bash
---

# Documentation Generator Skill

Automatically generates comprehensive documentation from code analysis.

## What It Does

- Generates API documentation from code
- Creates component documentation
- Builds README files
- Extracts inline documentation
- Formats documentation consistently

## When to Use

Activate when users:
- Request documentation generation
- Say "document this code"
- Ask for API docs
- Need README files
- Mention "generate docs"

## Generation Process

1. Analyze code structure and comments
2. Select appropriate template
3. Extract documentation from code
4. Generate formatted documentation
5. Save to appropriate location

## Templates

- `api-docs-template.md`: For API documentation
- `component-docs-template.md`: For component docs
- `readme-template.md`: For README files

## Usage

Specify which type of documentation to generate, or let Claude determine from context.
```

---

## When to Use Skills

### Use Skills When

✅ **Background Capabilities**

- Functionality that should be automatically available
- Context-aware assistance that Claude should provide
- Capabilities users might not know to ask for explicitly

✅ **Reusable Expertise**

- Domain-specific knowledge (TDD, security, architecture)
- Best practices and patterns
- Team-specific workflows

✅ **Cross-Cutting Concerns**

- Code quality analysis
- Documentation generation
- Testing strategies

### Use Slash Commands When

✅ **Explicit Workflows**

- Multi-step processes users want to control
- Sequential operations (create project → research → design)
- Commands users invoke at specific times

✅ **User-Driven Actions**

- Creating new projects
- Running specific analyses
- Generating specific artifacts

### Example Decisions

| Capability | Implementation | Rationale |
|------------|---------------|-----------|
| Create new project structure | **Slash Command** `/wb:create_project` | User explicitly starts projects |
| Suggest TDD approach | **Skill** `tdd-workflow` | Claude offers when writing code |
| Research codebase | **Slash Command** `/wb:create_research` | User controls when to research |
| Analyze code quality | **Skill** `code-analyzer` | Claude suggests during reviews |
| Generate documentation | **Skill** `doc-generator` | Claude offers when docs needed |

---

## Limitations and Considerations

### Current Limitations

1. **No Subdirectory Prefixes**
   - Unlike slash commands (`/wb:name`), skills use flat structure
   - Cannot organize into namespaces like `planning/` or `dev/`
   - Use naming conventions instead: `analyze-code`, `analyze-performance`

2. **Cannot Explicitly Invoke**
   - No `/skill-name` syntax available
   - Users cannot force skill activation
   - Purely context-based discovery

3. **Tool Restrictions Limited to Claude Code**
   - `allowed-tools` field only works in Claude Code
   - Other Claude interfaces ignore this field
   - Security feature not universally available

4. **Discovery Dependent**
   - Quality of description determines activation
   - Poorly written descriptions mean skills won't activate
   - Must test thoroughly with various phrasings

### Key Considerations

#### 1. Scope and Distribution

**Personal Skills** (`~/.claude/skills/`):

- Only available to you
- Not shared with team
- Private expertise and workflows

**Project Skills** (`.claude/skills/`):

- Committed to git repository
- Shared with entire team
- Team-wide reusable capabilities
- Versioned with project

**Plugin Skills**:

- Distributed with plugins
- Managed by plugin system
- Updated with plugin updates

#### 2. Security with allowed-tools

For team-shared project skills, use `allowed-tools` to:

- Whitelist only necessary tools
- Prevent accidental dangerous operations
- Apply principle of least privilege
- Document why each tool is needed

**Example - Restricted Skill:**

```yaml
---
name: read-only-analyzer
description: Analyzes code without making changes
allowed-tools:
  - Read
  - Grep
  - Glob
---
```

This skill cannot write files or execute bash commands.

#### 3. Description Quality

The description is **critical** for skill activation:

**Good Description Pattern:**

```
[What it does] + [When to use] + [Trigger terms]
```

**Example:**

```yaml
description: Implements Test-Driven Development (TDD) workflow following Red-Green-Refactor cycle. Use when user wants to implement features test-first, mentions TDD, or asks to write tests before code.
```

**Bad Descriptions:**

```yaml
description: Helps with testing.  # Too vague
description: Use this for code.   # No context
description: Analyzer tool.        # No trigger terms
```

#### 4. Supporting Files

Skills can include supporting files:

- Scripts for automation
- Templates for output
- Documentation for reference
- Configuration files

**Best Practice**: Reference supporting files in SKILL.md:

```markdown
## Analysis Process

1. Run `analyzer.sh` to collect metrics
2. Use `templates/report-template.md` for formatting
3. Reference `docs/metrics-guide.md` for interpretation
```

#### 5. Testing Skills

Test skill activation thoroughly:

```bash
# Test various phrasings
"Can you analyze this code?"
"What's the code quality like?"
"Help me understand code complexity"
"I need a code review"

# Verify skill activates correctly
# Check that correct tools are used
# Confirm output matches expectations
```

---

## Comparison with This Repository's Commands

### Current Setup (Slash Commands)

This repository uses **slash commands**, not skills:

```
claude-code/commands/wb/
├── create_project.md      → /wb:create_project
├── create_research.md     → /wb:create_research
├── create_design.md       → /wb:create_design
└── ...
```

These are **explicitly invoked** by users:

- User types `/wb:create_project my-feature`
- Command executes immediately
- User controls when and how

### If Converted to Skills

If these were skills instead:

```
.claude/skills/
├── project-creator/
│   └── SKILL.md
├── codebase-researcher/
│   └── SKILL.md
└── design-creator/
    └── SKILL.md
```

They would be **automatically invoked**:

- User says "I need to start a new feature"
- Claude determines project-creator skill is relevant
- Skill activates without user typing command

### Recommendation

**Keep current slash command approach** because:

- ✅ Users want explicit control over workflow steps
- ✅ Sequential process (project → research → design → tasks)
- ✅ Clear entry points for each phase
- ✅ Users know exactly when each step happens

**Consider skills for:**

- TDD guidance during implementation
- Code quality suggestions during reviews
- Documentation generation when coding
- Pattern detection during refactoring

---

## Summary

**Claude Code Skills** are powerful tools for packaging reusable expertise that Claude automatically discovers and applies based on context. They differ fundamentally from slash commands in that they're model-invoked rather than user-invoked, making them ideal for background capabilities and context-aware assistance.

### Key Takeaways

1. **Skills vs Commands**: Skills are automatic, commands are explicit
2. **Location**: `~/.claude/skills/` (personal) or `.claude/skills/` (project)
3. **Structure**: Directory with `SKILL.md` + optional supporting files
4. **Activation**: Claude decides based on description matching
5. **Security**: Use `allowed-tools` to restrict capabilities
6. **Best Practice**: Write specific descriptions with trigger terms

### Quick Reference

**Create a Skill:**

```bash
mkdir -p .claude/skills/my-skill
cat > .claude/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: What it does and when to use it with trigger terms
allowed-tools:
  - Read
  - Write
---

# My Skill

Instructions for Claude to follow when skill activates.
EOF
```

**Test Activation:**

Ask questions that should trigger the skill and verify Claude invokes it correctly.

---

## Further Resources

- **Official Documentation**: Claude Code documentation on skills
- **This Repository's Commands**: See `claude-code/commands/wb/` for slash command examples
- **Install Script**: `scripts/install-commands` for understanding command installation

---

*Last Updated: 2025-11-21*
*Based on: Claude Code official documentation research*
