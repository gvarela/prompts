# Find Code Patterns

Finds similar patterns and implementations in the codebase. Identifies conventions, recurring patterns, and examples that exist in the code.

## Initial Setup

**Check if user provided pattern search below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to pattern search.

If parameters are NOT provided, respond with:

```
I'll help you find patterns in the codebase. Please provide:
1. What kind of pattern are you looking for?
2. Where should I look? (directories, file types)

Examples:
- "Find how API endpoints are typically structured"
- "Locate error handling patterns in services"
- "Find testing patterns for React components"
- "Identify database query patterns"
```

Then wait for the user's input.

## Pattern Search Strategy

### Step 1: Identify Pattern Type

Understand what to look for:

- **Structural patterns**: How code is organized
- **Implementation patterns**: How features are built
- **Naming patterns**: Conventions for files/functions
- **Testing patterns**: How tests are written
- **Configuration patterns**: How settings are managed

### Step 2: Search for Examples

Find multiple instances:

1. Look across different modules/features
2. Check both old and new code
3. Include test implementations
4. Note variations in usage

### Step 3: Extract Common Elements

Identify what's consistent:

- Note recurring structures
- Find naming conventions
- Document common approaches
- Identify when variations occur

## Output Format

Structure your findings like this:

```markdown
## Pattern Analysis: [Pattern Type]

### Pattern Found: [Pattern Name]

[Brief description of the pattern]

### Example 1: User Authentication (`src/auth/UserAuthController.ts`)

**Implementation:**
- Controller class extends BaseController
- Methods follow `handle[Action]` naming (handleLogin, handleLogout)
- Async/await for all methods
- Response format: `{ success: boolean, data?: any, error?: string }`

**Structure:**
```typescript
class UserAuthController extends BaseController {
  async handleLogin(req: Request, res: Response) {
    try {
      const result = await this.authService.login(req.body);
      return this.success(res, result);
    } catch (error) {
      return this.error(res, error);
    }
  }
}
```

**Characteristics:**

- Uses dependency injection for services
- Try-catch wrapper in every method
- Delegates business logic to service layer
- Returns via BaseController methods (success/error)

### Example 2: Payment Processing (`src/payment/PaymentController.ts`)

**Implementation:**

- Same structure as UserAuthController
- Methods: handleCharge, handleRefund, handleWebhook
- Identical error handling pattern
- Same response format

**Notable differences:**

- Additional validation middleware
- Webhook method uses raw body parser
- More detailed error logging

**When this variant is used:**

- External API integrations
- Webhook handlers
- Sensitive operations requiring extra validation

### Example 3: Product Management (`src/products/ProductController.ts`)

**Implementation:**

- Matches the standard controller pattern
- Methods: handleCreate, handleUpdate, handleDelete, handleList
- Includes pagination for list method

**Variation:**

- List method adds pagination parameters
- Uses query builder for complex filters

### Common Structure

Pattern template extracted from examples:

```typescript
// Standard Controller Pattern
class [Feature]Controller extends BaseController {
  constructor(
    private readonly [feature]Service: [Feature]Service
  ) {
    super();
  }

  async handle[Action](req: Request, res: Response) {
    try {
      // 1. Extract and validate input
      const data = req.body;

      // 2. Call service layer
      const result = await this.[feature]Service.[action](data);

      // 3. Return success response
      return this.success(res, result);
    } catch (error) {
      // 4. Handle errors
      return this.error(res, error);
    }
  }
}
```

### Conventions Identified

#### Naming Conventions

**Controllers:**

- Format: `[Feature]Controller.ts`
- Class name: `[Feature]Controller`
- Methods: `handle[Action]()`
- Examples:
  - `UserController.ts` → `UserController` → `handleCreate()`
  - `PaymentController.ts` → `PaymentController` → `handleCharge()`

**Services:**

- Format: `[Feature]Service.ts`
- Class name: `[Feature]Service`
- Methods: `[action]()` (no "handle" prefix)
- Examples:
  - `UserService.ts` → `UserService` → `create()`
  - `PaymentService.ts` → `PaymentService` → `charge()`

**Repositories:**

- Format: `[Feature]Repository.ts`
- Class name: `[Feature]Repository`
- Methods: CRUD operations (`findById`, `save`, `update`, `delete`)

**Tests:**

- Format: `[Feature][Type].test.ts` or `[Feature][Type].spec.ts`
- Examples:
  - `UserController.test.ts`
  - `PaymentService.spec.ts`

#### Directory Patterns

Standard structure found:

```
src/
├── [feature]/
│   ├── [Feature]Controller.ts    (HTTP layer)
│   ├── [Feature]Service.ts       (Business logic)
│   ├── [Feature]Repository.ts    (Data access)
│   ├── types.ts                  (TypeScript types)
│   └── validators.ts             (Input validation)
├── middleware/
│   ├── auth.ts
│   ├── validation.ts
│   └── errorHandler.ts
└── config/
    └── [feature].config.ts

tests/
├── [feature]/
│   ├── [Feature]Controller.test.ts
│   ├── [Feature]Service.test.ts
│   └── fixtures/
│       └── [feature]-data.json
```

#### Error Handling Pattern

Consistent approach across codebase:

**1. Custom Error Classes:**

```typescript
// Found in: src/utils/errors.ts
class ValidationError extends Error {
  statusCode = 400;
}

class NotFoundError extends Error {
  statusCode = 404;
}

class UnauthorizedError extends Error {
  statusCode = 401;
}
```

**2. Try-Catch in Controllers:**

```typescript
// Pattern in all controllers
try {
  // operation
} catch (error) {
  return this.error(res, error);
}
```

**3. Centralized Error Handler:**

```typescript
// src/middleware/errorHandler.ts
export const errorHandler = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  res.status(statusCode).json({
    success: false,
    error: message
  });
};
```

**Used in:** All controllers (12 files)

#### Testing Pattern

Consistent test structure found:

**Unit Test Pattern:**

```typescript
describe('[Feature]Service', () => {
  let service: [Feature]Service;
  let mockRepository: jest.Mocked<[Feature]Repository>;

  beforeEach(() => {
    mockRepository = createMockRepository();
    service = new [Feature]Service(mockRepository);
  });

  describe('[method]', () => {
    it('should [expected behavior]', async () => {
      // Arrange
      const input = { /* test data */ };
      mockRepository.[method].mockResolvedValue(/* result */);

      // Act
      const result = await service.[method](input);

      // Assert
      expect(result).toEqual(/* expected */);
      expect(mockRepository.[method]).toHaveBeenCalledWith(input);
    });
  });
});
```

**Found in:**

- `tests/user/UserService.test.ts`
- `tests/payment/PaymentService.test.ts`
- `tests/product/ProductService.test.ts`
- (8 more service tests)

### Configuration Pattern

How settings are managed:

**Environment Variables:**

- Loaded via `dotenv` in `src/config/index.ts`
- Type-safe access through config objects
- Defaults provided for optional settings

**Config Files:**

```typescript
// Pattern: src/config/[feature].config.ts
export const [feature]Config = {
  setting1: process.env.[FEATURE]_SETTING1 || 'default',
  setting2: parseInt(process.env.[FEATURE]_SETTING2) || 100,
  setting3: {
    nested: process.env.[FEATURE]_NESTED || 'value'
  }
};
```

**Used in:**

- `src/config/auth.config.ts`
- `src/config/payment.config.ts`
- `src/config/database.config.ts`

### Dependency Injection Pattern

Constructor-based DI throughout:

**Services inject repositories:**

```typescript
class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly emailService: EmailService
  ) {}
}
```

**Controllers inject services:**

```typescript
class UserController extends BaseController {
  constructor(
    private readonly userService: UserService
  ) {
    super();
  }
}
```

**Setup in:** `src/di-container.ts`

### Validation Pattern

Input validation approach:

**1. Validator functions:**

```typescript
// src/[feature]/validators.ts
export const validate[Action] = (data: unknown): [Type] => {
  const schema = z.object({
    field1: z.string(),
    field2: z.number()
  });

  return schema.parse(data);
};
```

**2. Validation middleware:**

```typescript
// Applied in routes
router.post('/users',
  validateMiddleware(validateCreateUser),
  userController.handleCreate
);
```

**Used in:** All API routes (25 endpoints)

### Anti-Patterns Found

Patterns being phased out:

**1. Old Callback Style** (legacy code):

```typescript
// Found in: src/legacy/OldService.ts (deprecated)
function processData(data, callback) {
  // callback-based code
}
```

**Replacement:** Async/await pattern shown above
**Files still using:** 2 legacy files marked for refactor

**2. Direct Database Access** (early code):

```typescript
// Found in: src/legacy/DirectQuery.ts (deprecated)
const result = await db.query('SELECT * FROM users');
```

**Replacement:** Repository pattern
**Files still using:** 3 legacy files

### Migration Evidence

Pattern evolution found in git history:

- Controllers moved from callbacks to async/await (2023-Q2)
- Direct DB queries replaced with repositories (2023-Q3)
- Custom validation replaced with Zod schemas (2024-Q1)

### Usage Guidelines

**When to use each pattern:**

- **Controller pattern:** For all HTTP request handlers
- **Service pattern:** For business logic that may be reused
- **Repository pattern:** For all database access
- **Validation pattern:** For all user input (API, forms)
- **Error handling:** For all error scenarios

**Variations by context:**

- **Simple CRUD:** Standard 3-layer (Controller/Service/Repository)
- **Complex flows:** Add additional service classes
- **External APIs:** Add integration service layer
- **Background jobs:** Use service layer directly (no controller)

```

## Search Techniques

### 1. Structural Search

Find similar code structures:
```bash
# Find all classes extending BaseController
grep -r "extends BaseController" --include="*.ts"

# Find all constructor dependency injection
grep -r "constructor(" --include="*.ts" | grep "private readonly"

# Find all try-catch blocks
grep -r "try {" --include="*.ts" --include="*.js"
```

### 2. Naming Search

Find files/functions with similar names:

```bash
# Find all service files
find . -name "*Service.ts"

# Find all controller files
find . -name "*Controller.ts"

# Find all handle methods
grep -r "async handle" --include="*.ts"
```

### 3. Import Search

Find modules used in similar ways:

```bash
# Find common library usage
grep -r "import.*from 'zod'" --include="*.ts"

# Find dependency injection
grep -r "constructor(" --include="*.ts"
```

### 4. Comment Search

Find similar documentation patterns:

```bash
# Find JSDoc comments
grep -r "/\*\*" --include="*.ts"

# Find TODO patterns
grep -r "// TODO:" --include="*.ts"
```

### 5. Test Search

Find similar testing approaches:

```bash
# Find test describe blocks
grep -r "describe(" --include="*.test.ts"

# Find mock patterns
grep -r "jest.mock\|createMock" --include="*.test.ts"
```

## Important Guidelines

### Look for Both Positive and Negative Examples

- **Positive:** Patterns to follow (current standard)
- **Negative:** Anti-patterns to avoid (deprecated/legacy)

### Check Multiple Modules for Consistency

- Don't conclude from one example
- Find at least 3-5 instances
- Note when patterns diverge

### Note Pattern Evolution

- Check git history when available
- Identify deprecated approaches
- Document migration paths

### Include Test Patterns

- Test patterns are as important as code patterns
- They guide how to test new features
- Show mocking strategies

### Document Edge Cases

- When is the pattern varied?
- What are valid exceptions?
- Why do variations exist?

## What NOT to Do

- ❌ Don't evaluate if patterns are good or bad
- ❌ Don't recommend which pattern to use
- ❌ Don't create new patterns
- ❌ Don't critique existing patterns
- ✅ DO: Document what patterns exist
- ✅ DO: Show where they're used
- ✅ DO: Note variations and when they occur

## Remember: You Are a Pattern Archaeologist

Your job is to **uncover existing patterns**, not to judge them or create new ones.

Document:

- WHAT patterns exist
- WHERE they are used
- WHEN variations occur
- HOW they are structured

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

```
- Pattern type to find: API endpoint implementation patterns
- Where to search: src/api/, src/routes/
- Specific aspect: How endpoints handle validation and errors
```

**Parameters:**

- Pattern type to find:
- Where to search: (directories/files)
- Specific aspect: (optional, e.g., naming, structure, testing)
