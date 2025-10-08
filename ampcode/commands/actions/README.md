# AmpCode Action Commands

Focused commands for analyzing and understanding codebases. These commands help you locate components, analyze implementations, and identify patterns without making changes.

## Overview

Action commands are specialized for **read-only codebase analysis**:

- **`/locate_code`** - Find specific components and files in the codebase
- **`/analyze_code`** - Understand how implementations work
- **`/find_patterns`** - Identify conventions and recurring patterns

## Philosophy: Document, Don't Judge

These commands follow a strict **documentarian** approach:

✅ **DO:**

- Describe what exists
- Explain how code works
- Document patterns found
- Provide file:line references
- Trace data flow

❌ **DO NOT:**

- Suggest improvements
- Identify bugs or issues
- Critique implementation
- Make recommendations
- Propose changes

## Commands

### `/locate_code` - Find Components

Finds where features are implemented in the codebase.

**Use when:**

- Looking for a specific component or feature
- Need to find all files related to functionality
- Want to map the codebase structure
- Finding test files for a component

**Example usage:**

```
/locate_code

What to find: User authentication components
File types: .ts, .tsx
Directories: src/auth/, tests/auth/
```

**What it returns:**

- Primary implementation files
- Related test files
- Configuration files
- Documentation
- Directory structure
- Import/export map

### `/analyze_code` - Understand Implementation

Analyzes how specific components work with precise technical details.

**Use when:**

- Need to understand how a feature works
- Tracing data flow through the system
- Understanding integration points
- Documenting technical implementation

**Example usage:**

```
/analyze_code

Component: Payment processing
Aspect: How charges are processed from API to gateway
Starting files: src/payment/PaymentService.ts
```

**What it returns:**

- Entry points and main functions
- Step-by-step data flow
- Key implementation details (with file:line refs)
- Dependencies and integrations
- Error handling approach
- Configuration used

### `/find_patterns` - Identify Conventions

Finds recurring patterns and conventions in the codebase.

**Use when:**

- Learning codebase conventions
- Finding examples to follow for new code
- Understanding how to structure similar features
- Identifying testing patterns

**Example usage:**

```
/find_patterns

Pattern type: API endpoint implementation
Where to search: src/api/, src/routes/
Specific aspect: Error handling and validation patterns
```

**What it returns:**

- Multiple examples of the pattern
- Common structure/template
- Naming conventions
- Directory organization
- Variations and when they're used
- Anti-patterns to avoid

## Command Workflow

These commands work well together:

```
1. /locate_code
   ↓
   Find where components live

2. /analyze_code
   ↓
   Understand how they work

3. /find_patterns
   ↓
   Identify conventions to follow
```

### Example: Understanding Authentication

```bash
# Step 1: Find the components
/locate_code
> Find authentication components

# Result: Located AuthService, middleware, routes, tests

# Step 2: Analyze the implementation
/analyze_code
> Analyze how login flow works in AuthService

# Result: Detailed flow from request to JWT generation

# Step 3: Find the pattern
/find_patterns
> Find authentication patterns across the codebase

# Result: Standard auth pattern used in 3 other features
```

## Usage Patterns

### Quick Investigation

When you need fast answers:

```
/locate_code
> Find payment processing components
```

Get file locations, then read them yourself.

### Deep Dive

When you need full understanding:

```
# First locate
/locate_code
> Payment processing

# Then analyze
/analyze_code
> Analyze payment processing data flow
```

### Learning the Codebase

When joining a new project:

```
# Find patterns
/find_patterns
> API endpoint patterns

# Locate examples
/locate_code
> Example API endpoints

# Analyze implementation
/analyze_code
> How endpoints handle validation
```

## AmpCode-Specific Features

### Parameter Pre-filling

Fill in the "User Input Section" before submitting:

```markdown
/locate_code

---

## User Input Section

- What to find: User authentication
- File types to search: .ts, .tsx
- Directories to focus on: src/auth/
```

### Interactive Mode

Submit without parameters for guided prompts:

```markdown
/locate_code

[submit with blank User Input Section]

AI: What component are you looking for?
You: User authentication components
```

## Integration with Planning Commands

Action commands complement planning commands:

### Research Phase

Use actions during `/create_research`:

```bash
# Start research
/create_research docs/plans/2025-10-08-my-project

# During research, use actions to gather info
/locate_code     # Find relevant components
/analyze_code    # Understand how they work
/find_patterns   # Identify conventions

# Results feed into research.md
```

### Planning Phase

Use actions during `/create_plan`:

```bash
# Start planning
/create_plan docs/plans/2025-10-08-my-project

# Use actions to verify approach
/find_patterns   # See how similar features are built
/analyze_code    # Understand integration points

# Results inform plan decisions
```

## Best Practices

### 1. Be Specific

Better:

```
Component: User authentication in AuthService
Aspect: JWT token generation and validation
Starting files: src/auth/AuthService.ts
```

Not:

```
Component: Auth stuff
```

### 2. Use Together

Locate → Analyze → Find Patterns

Each command builds on the previous.

### 3. Start Broad, Then Narrow

```
1. /locate_code (find all auth components)
2. /analyze_code (deep dive on AuthService)
3. /find_patterns (see how auth is used everywhere)
```

### 4. Reference Results in Documentation

Copy findings into:

- Research documents
- Architecture docs
- Onboarding materials
- Technical specifications

## Command Limitations

These commands are **read-only analysis tools**:

- ❌ Won't write code
- ❌ Won't modify files
- ❌ Won't suggest changes
- ❌ Won't identify problems
- ✅ Will document what exists
- ✅ Will explain how things work
- ✅ Will find examples

For making changes, use other commands or request modifications separately.

## Output Quality

### What to Expect

**Locate Code:**

- Comprehensive file lists
- Directory structures
- Import/export maps
- Categorized results

**Analyze Code:**

- File:line references for every claim
- Step-by-step data flow
- Exact function/variable names
- Configuration details

**Find Patterns:**

- Multiple concrete examples
- Common structure templates
- Naming conventions
- Usage guidelines

### What NOT to Expect

- Opinions about code quality
- Suggestions for improvements
- Bug reports
- Architecture recommendations
- Performance optimization ideas

## Installation

These commands are installed with the planning commands:

```bash
# Install all AmpCode commands globally
./scripts/install-commands --amp

# Or install to specific project
./scripts/install-commands --amp --project ~/my-project
```

Commands will be available as:

- `/locate_code`
- `/analyze_code`
- `/find_patterns`

## Troubleshooting

### Command Not Found

Check installation:

```bash
ls ~/.config/amp/commands/actions/
# or
ls .agents/commands/actions/
```

Should see:

- `locate_code.md`
- `analyze_code.md`
- `find_patterns.md`

### No Results Returned

Try broader search:

- Use wildcards: `*auth*`
- Search more directories
- Try different naming patterns

### Too Many Results

Narrow the search:

- Specify file types
- Limit to specific directories
- Use more specific search terms

## See Also

- [AmpCode Planning Commands](../planning/README.md)
- [AmpCode Usage Guide](../../README.md)
- [Command Philosophy](../planning/CLAUDE.md)
