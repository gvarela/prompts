# implement_coordinated — Reference

Specs and playbooks consulted at specific steps. Read the relevant section in full when its step directs you here.

## Context Package Structure (Step 3)

Build exactly this structure from the documentation you've read — only what workers actually need:

```javascript
const contextPackage = {
  // From research.md - patterns workers must follow
  patterns: {
    testingFramework: "jest | pytest | go test | ...",
    testFileLocation: "tests/ | __tests__ | *_test.go | ...",
    fileStructure: "src/ layout | pkg/ layout | ...",
    namingConventions: "camelCase | snake_case | ...",
    importPatterns: "how modules are imported",
    errorHandling: "established patterns"
  },

  // From design.md - relevant to this phase
  design: {
    phaseGoal: "what this phase achieves",
    successCriteria: ["criterion 1", "criterion 2"],
    constraints: ["constraint 1", "constraint 2"],
    architecturalApproach: "key decisions"
  },

  // From tasks.md frontmatter
  beads: {
    epicId: "beads-xxx",
    phaseMilestoneId: "beads-yyy",
    mode: "$BEADS_MODE"
  },

  // Test commands
  testCommands: {
    unit: "npm test | pytest | go test ./...",
    specific: "npm test path/to/file | pytest tests/file.py",
    coverage: "npm test -- --coverage | pytest --cov"
  },

  // File references relevant to this phase
  relevantFiles: [
    "src/feature/file1.ts:123 - existing pattern to follow",
    "tests/feature/test1.spec.ts:45 - test structure example"
  ]
};
```

## Determine Worker Model (Step 5)

```javascript
function determineModel(taskDetails) {
  // Extract complexity indicators from task
  const description = taskDetails.description.toLowerCase();
  const title = taskDetails.title.toLowerCase();
  const combined = `${title} ${description}`;

  // Haiku for simple tasks (config, docs, renames)
  const haikuPatterns = [
    /\b(config|configuration|env|environment variable)/,
    /\b(documentation|readme|comment|doc string)/,
    /\b(rename|move|delete)\s+(file|directory|folder)/,
    /\b(update|change)\s+(version|dependency)/,
    /\btypo\b/
  ];

  for (const pattern of haikuPatterns) {
    if (pattern.test(combined)) {
      return 'haiku';
    }
  }

  // Sonnet for straightforward implementation tasks
  const sonnetPatterns = [
    /\b(implement|add|create|build|write)\s+(test|unit test)/,
    /\b(add|create)\s+(function|method|class|component)/,
    /\b(wire up|integrate|connect)\b/,
    /\b(update|modify)\s+(existing|current)/
  ];

  for (const pattern of sonnetPatterns) {
    if (pattern.test(combined)) {
      return 'sonnet';
    }
  }

  // Default → opus (conservative, better at complex tasks)
  // This includes: bug fixing, refactoring, architecture, algorithms, security
  return 'opus';
}
```

## Worker Failure Playbook (Step 6)

If a worker leaves its task in `in_progress` (didn't close the beads issue), the worker crashed or couldn't complete. Verification is NOT run when the worker didn't finish — that path is for verification FAILs after successful completion.

Present:

```
⚠️ Worker Did Not Complete Task

Task ${taskId} status: in_progress (should be closed)
Worker reported: ${workerError}

This means the worker crashed or couldn't complete the task.
Verification agent is NOT run if worker didn't finish.

**Options**:
1. Retry worker with same context
2. Retry worker with additional context
3. Mark task as blocked, investigate
4. Manual intervention required

How should I proceed?
```
