# Locate Code Components

Finds specific components, files, and implementations in the codebase. Specializes in locating where features are implemented and mapping codebase structure.

## Initial Setup

**Check if user provided search terms below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to search.

If parameters are NOT provided, respond with:

```
I'll help you locate components in the codebase. Please provide:
1. What component/feature are you looking for?
2. Any specific file types or directories to focus on? (optional)

Examples:
- "Find authentication components"
- "Locate all API route handlers"
- "Find where User model is defined and used"
```

Then wait for the user's input.

## Search Strategy

### Step 1: Understand the Request

From user input, identify:

- **What to find**: Specific component, feature, class, or function
- **File types**: Source files, tests, configs, docs
- **Directories**: Which parts of codebase to search

### Step 2: Execute Searches

Use multiple search strategies in parallel:

**1. Name-based search:**

```bash
# Search for files by name
find . -name "*[component-name]*" -type f

# Or use glob patterns
# Look for TypeScript/JavaScript files
**/*[component-name]*.{ts,tsx,js,jsx}

# Look for test files
**/*[component-name]*.{test,spec}.{ts,js}
```

**2. Content-based search:**

```bash
# Search for class definitions
grep -r "class [ComponentName]" --include="*.ts" --include="*.js"

# Search for function definitions
grep -r "function [functionName]" --include="*.ts" --include="*.js"

# Search for exports
grep -r "export.*[ComponentName]" --include="*.ts"
```

**3. Import/usage search:**

```bash
# Find where component is imported
grep -r "import.*[ComponentName]" --include="*.ts" --include="*.js"

# Find where component is used
grep -r "[ComponentName]" --include="*.tsx" --include="*.jsx"
```

**4. Convention-based search:**

Check standard locations:

- `src/components/` - UI components
- `src/services/` - Business logic services
- `src/models/` or `src/entities/` - Data models
- `src/api/` or `src/routes/` - API endpoints
- `src/utils/` or `src/lib/` - Utilities
- `tests/` or `__tests__/` - Test files
- `config/` - Configuration files

### Step 3: Verify and Organize Results

Check each found file to confirm it contains what was requested:

- Read file headers/exports to verify
- Note file purposes and relationships
- Eliminate false positives
- Group by category (source, tests, config, docs)

## Output Format

Structure your findings like this:

```markdown
## Located: [Component/Feature Name]

### Primary Implementation

- `src/auth/AuthService.ts` - Main authentication service
- `src/auth/types.ts` - Type definitions for auth
- `src/auth/middleware.ts` - Authentication middleware

### Test Files

- `tests/auth/AuthService.test.ts` - Unit tests
- `tests/integration/auth.test.ts` - Integration tests
- `tests/e2e/auth.spec.ts` - End-to-end tests

### Configuration

- `config/auth.config.ts` - Authentication configuration
- `.env.example` - Environment variables (AUTH_* vars)

### Related Components

- `src/users/UserService.ts` - User management (imports AuthService)
- `src/api/routes/auth.ts` - Auth API routes (uses AuthService)

### Documentation

- `docs/authentication.md` - Authentication documentation
- `README.md` - Contains auth setup instructions

### Directory Structure

```

src/auth/
├── AuthService.ts      (main service)
├── types.ts            (type definitions)
├── middleware.ts       (Express middleware)
└── validators.ts       (input validation)

tests/auth/
├── AuthService.test.ts
└── fixtures/
    └── auth-data.json

```

### Import/Export Map

**Exported from:** `src/auth/AuthService.ts`
**Imported by:**
- `src/api/routes/auth.ts:3`
- `src/api/middleware/requireAuth.ts:5`
- `src/users/UserService.ts:8`
- `tests/auth/AuthService.test.ts:2`

### File Locations Summary

Quick reference for navigation:
- Main: `src/auth/AuthService.ts`
- Types: `src/auth/types.ts`
- Config: `config/auth.config.ts`
- Tests: `tests/auth/AuthService.test.ts`
- Docs: `docs/authentication.md`
```

## Search Techniques

### By Name

Search for files/functions by name:

```bash
# Find files with "auth" in name
find . -iname "*auth*" -type f

# Case-insensitive grep
grep -ri "AuthService" .
```

### By Pattern

Find code matching specific patterns:

```bash
# Find all class definitions
grep -r "^class " --include="*.ts"

# Find all exported functions
grep -r "^export function" --include="*.ts"

# Find all React components
grep -r "React.Component\|function.*Component" --include="*.tsx"
```

### By Import

Locate where modules are imported:

```bash
# Find imports of specific module
grep -r "from ['\"].*AuthService" --include="*.ts"

# Find all imports from a directory
grep -r "from ['\"]@/auth" --include="*.ts"
```

### By Convention

Use naming conventions to find files:

- Controllers: `*Controller.ts`, `*.controller.ts`
- Services: `*Service.ts`, `*.service.ts`
- Models: `*Model.ts`, `*.model.ts`
- Repositories: `*Repository.ts`, `*.repository.ts`
- Tests: `*.test.ts`, `*.spec.ts`

## Important Guidelines

### Cast Wide Net Initially

- Start with broad searches
- Then filter and narrow down
- Don't assume standard locations without checking
- Check multiple naming conventions

### Include All Related Files

- Don't skip test files
- Include configuration
- Find documentation
- Locate examples

### Note Conventions

- Observe naming patterns used
- Document directory structure
- Identify file organization
- Record import patterns

### Map Full Ecosystem

- Find not just the component, but everything related
- Include usage examples
- Document dependencies
- Show relationships

## What NOT to Do

- ❌ Don't analyze code functionality (just find it)
- ❌ Don't make recommendations about structure
- ❌ Don't suggest improvements
- ❌ Don't critique organization
- ✅ DO: Find everything related to what's requested
- ✅ DO: Be thorough and systematic
- ✅ DO: Provide exact file paths
- ✅ DO: Show relationships between files

## Example Searches

### Find Authentication Components

```
Search for: "authentication", "auth"
File types: .ts, .js
Directories: src/, tests/, config/
Look for: classes, services, middleware, routes, tests
```

### Find API Endpoints

```
Search for: "route", "endpoint", "api"
File types: .ts, .js
Directories: src/api/, src/routes/
Look for: route handlers, controllers, middleware
```

### Find Database Models

```
Search for: "model", "entity", "schema"
File types: .ts, .js
Directories: src/models/, src/entities/, src/db/
Look for: class definitions, Mongoose schemas, TypeORM entities
```

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

```
- What to find: User authentication components
- File types to search: .ts, .tsx
- Directories to focus on: src/auth/, tests/auth/
```

**Parameters:**

- What to find:
- File types to search: (optional, e.g., .ts, .tsx, .js)
- Directories to focus on: (optional, e.g., src/, tests/)
