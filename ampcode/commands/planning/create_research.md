# Generate Research Document

You are tasked with conducting comprehensive research across the codebase to answer user questions by spawning parallel sub-agents and synthesizing their findings.

## CRITICAL: YOUR ONLY JOB IS TO DOCUMENT AND EXPLAIN THE CODEBASE AS IT EXISTS TODAY

- DO NOT suggest improvements or changes unless the user explicitly asks for them
- DO NOT perform root cause analysis unless the user explicitly asks for them
- DO NOT propose future enhancements unless the user explicitly asks for them
- DO NOT critique the implementation or identify problems
- DO NOT recommend refactoring, optimization, or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map/documentation of the existing system

## Initial Setup

**Check if user provided parameters below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to research.

If parameters are NOT provided, respond with:

```
I'm ready to research the codebase and document findings. Please provide:
1. Path to the project documentation directory (e.g., docs/plans/2025-10-07-my-project/)
2. Your research question or area of interest

I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's input.

## Steps to Execute After Receiving the Research Query

### Step 1: Read Any Directly Mentioned Files First (CRITICAL)

- If the user mentions specific files (docs, JSON, configs), read them FULLY first
- **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
- **CRITICAL**: Read these files yourself in the main context before spawning any sub-tasks
- This ensures you have full context before decomposing the research

**⛔ BARRIER 1**: Do not proceed to Step 2 until ALL mentioned files are fully read

### Step 2: Validate Project Structure

- Check that the specified directory exists
- Verify research.md file exists (created by `/create_project`)
- Read the current research.md FULLY to see what's already documented
- Check frontmatter status field

### Step 3: Analyze and Decompose the Research Question

**think deeply**

1. **Break down the user's query into composable research areas**
2. **Take time to ultrathink about:**
   - Underlying patterns and connections
   - Architectural implications the user might be seeking
   - Which directories, files, or architectural patterns are relevant
3. **Create a research plan using TodoWrite** to track all subtasks:

   ```
   - [ ] Research authentication flow
   - [ ] Find all user validation points
   - [ ] Document API endpoints
   - [ ] Analyze database schema
   ```

4. **Consider which specific components** to investigate

### Step 4: Spawn Parallel Sub-Agent Tasks for Comprehensive Research

Create multiple Task agents to research different aspects concurrently.

**IMPORTANT**: All agents are documentarians, not critics. They will describe what exists without suggesting improvements or identifying issues.

#### Agent Strategy

For each agent, include this directive:

```
You are documenting the codebase as it exists. DO NOT suggest improvements or identify issues.
Your job is to describe WHAT exists and HOW it works, not what should be changed.
Document what IS, not what SHOULD BE.
```

#### Types of Research Agents to Spawn

**Code Locator Agents** - Find WHERE files and components live:

```
Task: "Find authentication components"
Prompt: "Spawn a subagent and search the codebase for all files related to authentication.
Use Grep to search for keywords: auth, login, session, token, user
Use Glob for patterns: **/auth*.*, **/*login*, **/*session*
Focus on: code (not test or config) directories
Return a categorized list of files with their purpose.
Document what exists, do not evaluate quality."
```

**Code Analyzer Agents** - Understand HOW specific code works:

```
Task: "Analyze user validation flow"
Prompt: "Spawn a subagent and read and analyze the user validation implementation.
Start with [specific files identified].
Document:
- How validation works step by step
- Data flow from entry to exit
- Key functions and their purposes
- Integration points with other systems
Include specific file:line references.
Document how it works, not how it should work."
```

**Pattern Finder Agents** - Find examples of existing patterns:

```
Task: "Find error handling patterns"
Prompt: "Spawn a subagent and search for existing error handling implementations.
Look for try/catch blocks, error classes, error middleware.
Find at least 3 different examples.
Return code examples with file:line references.
Document the patterns without evaluating them."
```

#### Parallel Execution Example

```python
# Spawn these tasks concurrently:
tasks = [
    Task("Locate all user-related files", locator_prompt, subagent_type="codebase-locator"),
    Task("Analyze current authentication flow", analyzer_prompt, subagent_type="codebase-analyzer"),
    Task("Find existing validation patterns", pattern_prompt, subagent_type="pattern-finder"),
    Task("Document API endpoint structure", api_prompt, subagent_type="codebase-analyzer")
]
```

**Key instructions for all agents:**

- Start with locator agents to find what exists
- Then use analyzer agents on the most promising findings
- Run multiple agents in parallel when they're searching for different things
- Each agent knows its job - just tell it what you're looking for
- Don't write detailed prompts about HOW to search - the agents already know
- Remind agents they are documenting, not evaluating or improving

**⛔ BARRIER 2**: Wait for ALL sub-agents to complete before proceeding to Step 5

### Step 5: Synthesize Findings

**IMPORTANT**: Wait for ALL sub-agent tasks to complete before proceeding

1. **Compile all sub-agent results**
2. **Prioritize live codebase findings** as primary source of truth
3. **Connect findings across different components**
4. **Include specific file paths and line numbers** for reference
5. **Highlight patterns, connections, and architectural decisions**
6. **Answer the user's specific questions** with concrete evidence

### Step 6: Document Findings

Update the research.md file with:

````markdown
---
project: [from existing frontmatter]
ticket: [from existing frontmatter]
created: [from existing frontmatter]
status: complete
last_updated: [YYYY-MM-DD]
---

# Research: [Project Name]

**Created**: [original date]
**Last Updated**: [YYYY-MM-DD]
**Ticket**: [ticket-reference or N/A]

## Research Question

[Original user query]

## Summary

[High-level documentation of what was found, answering the user's question by describing what exists - 2-3 paragraphs]

## Detailed Findings

### [Component/Area 1]

**Location**: `path/to/component/`

**What exists**:
- Description of current implementation ([`file.ext:123`](link))
- How it connects to other components
- Current implementation details (without evaluation)

**Key code**:
```language
// Actual code snippet from file.ext:123-145
// Showing how it currently works
```

**How it works**:

1. [Step-by-step explanation of current flow]
2. [With specific file:line references]
3. [Describing actual behavior]

### [Component/Area 2]

[Continue pattern...]

## Architecture Documentation

**Current patterns found**:

- Pattern 1: [Description of pattern and where used]
  - Example: `src/auth/validator.ts:45-67`
  - Example: `src/api/middleware.ts:23-30`

**Component connections**:

- [Component A] → [Component B]: [How they interact]
  - Entry point: `file1.ext:123`
  - Exit point: `file2.ext:456`

**Conventions observed**:

- Files are organized by [observed pattern]
- Naming follows [observed convention]
- Testing uses [observed approach]

## Code References

Quick reference list:

- `path/to/file1.ext:123` - Main entry point for X
- `path/to/file2.ext:45-67` - Core validation logic
- `path/to/file3.ext:89` - Database queries for Y
- `path/to/file4.ext:200-250` - Error handling implementation

## Similar Implementations

Existing patterns in the codebase that might be relevant:

**Example from `path/to/example.ext:100-120`**:

```language
// Code showing similar pattern already in use
```

This pattern is also used in:

- `other/file.ext:50` - For feature X
- `another/file.ext:75` - For feature Y

## Knowledge Gaps

Things we couldn't determine from codebase analysis:

- [Fact we couldn't find in code/docs]
- [System behavior that's unclear]
- [Configuration or dependency not documented]

Note: These gaps don't block design but may affect implementation details.

````

**⛔ BARRIER 3**: Verify no placeholder values before writing. All data must be real.

### Step 7: Handle Follow-Up Questions

If the user has follow-up questions:

1. **DO NOT create a new research file**
2. **Append to the existing research.md**
3. **Add new section**: `## Follow-up Research [YYYY-MM-DD HH:MM]`
4. **Update frontmatter**:
   - `last_updated: [YYYY-MM-DD]`
   - Add: `last_updated_note: "Added research on [topic]"`
5. **Spawn new sub-agents** for additional investigation
6. **Continue building** on previous findings

### Step 8: Confirm Completion

Present summary to user:

```

✅ Research documented at: [path]/research.md

Research topic: [description]

Key findings:

- [Major finding 1 with file reference]
- [Major finding 2 with file reference]
- [Major finding 3 with file reference]

Files analyzed: [count]
Code references documented: [count]

Knowledge gaps identified: [count]

The research document has been updated with:

- Detailed findings about [component 1]
- Architecture documentation for [system]
- [X] similar implementation examples
- [Y] knowledge gaps that need resolution

Next: Review and validate the research, then run `/create_design` to make architectural decisions.

```

## Important Notes

### Critical Ordering

- **ALWAYS** read mentioned files first before spawning sub-tasks (Step 1)
- **ALWAYS** wait for all sub-agents to complete before synthesizing (Step 4)
- **NEVER** write the research document with placeholder values

### Documentation Philosophy

- **CRITICAL**: You and all sub-agents are documentarians, not evaluators
- **REMEMBER**: Document what IS, not what SHOULD BE
- **NO RECOMMENDATIONS**: Only describe the current state of the codebase
- Focus on finding concrete file paths and line numbers for developer reference
- Research documents should be self-contained with all necessary context
- Each sub-agent prompt should be specific and focused on read-only documentation operations
- Document cross-component connections and how systems interact

### File Reading

- **File reading**: Always read mentioned files FULLY (no limit/offset) before spawning sub-tasks
- Have sub-agents document examples and usage patterns as they exist
- Keep the main agent focused on synthesis, not deep file reading

### Synchronization Points

1. ⛔ **BARRIER 1**: After reading mentioned files - Do not proceed until ALL files are read
2. ⛔ **BARRIER 2**: After spawning agents - Wait for ALL agents to complete
3. ⛔ **BARRIER 3**: Before writing output - Verify no placeholder values

## Configuration

This command conducts comprehensive codebase research using parallel agents. See the User Input Section at the bottom to provide parameters directly, or submit without parameters for interactive mode.

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

- Project directory: docs/plans/2025-10-08-my-feature
- Research question: How do we currently handle authentication and session management?

**Parameters:**

- Project directory:
- Research question:
