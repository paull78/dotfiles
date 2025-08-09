---
description: Create PRD and task list for a new feature (solo developer focused)
allowed-tools: Edit, Write, Bash(find:*), Bash(git:*)
---

# Feature PRD & Task List Creator

Create PRD and task list for feature: $ARGUMENTS

## Current Project Context:
!`find . -name "README.md" -o -name "package.json" | head -3`
!`git branch --show-current`
!`find . -name "docs" -type d | head -1`

## Project Integration Analysis:
- Review existing codebase patterns: @README.md
- Identify integration points with current features
- Analyze existing tech stack and architecture

## Interactive Setup:

### Branch Planning:
Ask the user: "What branch name would you like for this feature? (e.g., feature/user-auth, feat/search-api)"
- Record the chosen branch name in the PRD
- Note: User will create this branch when ready to start implementation

## PRD Structure:

### 1. Feature Overview
- **Feature Name**: $ARGUMENTS
- **Branch Name**: [user-specified branch name]
- **Description**: What this feature does and why it's needed
- **Integration Points**: How it connects with existing code

### 2. Requirements
- **Functional Requirements**: Core functionality that must work
- **Technical Requirements**: Performance, security, compatibility needs
- **Database Changes**: New tables, migrations, schema updates
- **API Changes**: New endpoints, modifications to existing ones

### 3. Implementation Architecture
- **Backend Components**: Services, models, controllers needed
- **Frontend Components**: UI components and pages required
- **Database Design**: Schema changes and data models
- **External Integrations**: Third-party APIs or services

### 4. Task List
Create a detailed, ordered task list in `TASKS.md`:

```markdown
# Implementation Tasks for [Feature Name]

**Branch**: [branch-name]
**Status**: Planning

## Database & Backend Tasks
- [ ] 1. Create database migrations for [specific tables]
- [ ] 2. Implement [Model] model with relationships
- [ ] 3. Create [Service] service for business logic
- [ ] 4. Implement API endpoints: [list specific endpoints]
- [ ] 5. Add authentication/authorization for new endpoints
- [ ] 6. Write backend unit tests

## Frontend Tasks  
- [ ] 7. Create [Component] UI component
- [ ] 8. Implement [Page] page with routing
- [ ] 9. Add state management for [feature data]
- [ ] 10. Integrate with backend API endpoints
- [ ] 11. Add form validation and error handling
- [ ] 12. Write frontend tests

## Integration & Polish
- [ ] 13. Test integration with existing features
- [ ] 14. Add error handling and edge cases
- [ ] 15. Update documentation
- [ ] 16. Final testing and cleanup

**Next Task**: Task 1 - Create database migrations
```

## File Organization:
Create in: `docs/features/[feature-name]/`

```
docs/features/[feature-name]/
├── README.md          # Feature overview and requirements
├── TASKS.md           # Ordered task list with checkboxes
└── ARCHITECTURE.md    # Technical implementation details
```

## Output Requirements:
- **Ask for branch name** and record it prominently
- **Create ordered, specific tasks** (not vague descriptions)
- **Make tasks atomic** (each can be completed in one session)
- **Include "Next Task" pointer** for easy resumption
- **Focus on solo developer workflow** (no team coordination)
- **Keep it practical** and implementation-focused

Generate a focused PRD with a clear, actionable task list ready for solo implementation.
