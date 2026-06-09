# create_mockup — Sub-Agent Prompts

Read the relevant section in full when its step directs you here; match its structure exactly.

## Layout Patterns Researcher (Step 1)

```
You are documenting the codebase UI as it exists.

Find and document:
- Page layout patterns (grid, flex, containers)
- Navigation structure
- Content area organization
- Responsive breakpoints

Return with file:line references. DO NOT suggest improvements.
```

## Component Library Researcher (Step 1)

```
You are documenting the codebase UI as it exists.

Find and document:
- Existing component library (buttons, forms, cards, modals)
- Component naming conventions
- Props/API patterns
- Where components are defined

Return with file:line references. DO NOT suggest improvements.
```

## Styling Patterns Researcher (Step 1)

```
You are documenting the codebase styling as it exists.

Find and document:
- CSS approach (CSS modules, Tailwind, styled-components, etc.)
- Color tokens/variables
- Typography scale
- Spacing system
- Theme configuration

Return with file:line references. DO NOT suggest improvements.
```

## Similar Features Researcher (Step 1)

```
You are documenting similar features in the codebase.

Find examples of:
- Similar panels/modals/pages to [feature description]
- How similar features are structured
- Patterns for [feature type] in this codebase

Return with file:line references. DO NOT suggest improvements.
```

## Icon System Researcher (Step 1)

```
You are documenting the icon system as it exists.

Find and document:
- Icon library used (Font Awesome, Material Icons, Heroicons, SVG sprites, custom, etc.)
- Where icons are defined/imported (file:line references)
- How icons are referenced in components (class names, components, imports)
- Icon sizing and color conventions
- Examples of icon usage with file:line references
- Pattern for icons in buttons, headers, navigation

Return exact patterns found. If NO icon system exists, state that clearly.
DO NOT suggest adding an icon library if none exists.
```
