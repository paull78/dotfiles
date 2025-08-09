---
description: Start implementing a feature based on existing PRD documentation
allowed-tools: Edit, Write, Bash(find:*), Bash(git:*)
---

# Feature Implementation Starter

Begin implementing feature: $ARGUMENTS

## Find & Load Feature Documentation:
!`find docs/features -name "*$ARGUMENTS*" -type d | head -1`
!`git branch --show-current`

## Implementation Kickoff Process:

### 1. Load Feature Context:
- Review feature overview: @docs/features/[feature-name]/README.md
- Study implementation plan: @docs/features/[feature-name]/03-implementation-plan.md
- Understand technical architecture: @docs/features/[feature-name]/02-technical-architecture.md
- Check current requirements: @docs/features/[feature-name]/01-requirements.md

### 2. Verify Development Setup:
- Confirm we're on the correct feature branch
- Ensure all dependencies are understood
- Validate that prerequisites are complete
- Review integration points with existing code

### 3. Phase 1 Implementation:
Based on the implementation plan, start with the first development phase:
- **Database/Schema Changes** (if required)
- **Core Backend Services** (business logic)
- **API Endpoints** (following specification)
- **Frontend Components** (UI implementation)
- **Integration Points** (connecting with existing features)

### 4. Development Guidelines:
- **Follow the technical architecture** outlined in the PRD
- **Reference API specifications** when building endpoints
- **Implement according to requirements** with proper validation
- **Add comprehensive tests** as outlined in testing strategy
- **Document implementation decisions** in progress tracking

### 5. Implementation Commands:

#### Start Database Changes:
```
> Based on @docs/features/[feature-name]/05-database-design.md, 
> implement the database schema changes for [feature-name]
> Create migration files following our project's migration pattern
```

#### Implement API Endpoints:
```
> Using the API specification in @docs/features/[feature-name]/04-api-specification.md,
> implement the REST endpoints for [feature-name]
> Follow our existing API patterns and error handling
```

#### Build Frontend Components:
```
> Following the requirements in @docs/features/[feature-name]/01-requirements.md,
> create the frontend components for [feature-name]
> Use our existing design system and component patterns
```

#### Add Tests:
```
> Implement the test cases defined in @docs/features/[feature-name]/06-testing-strategy.md
> Include unit tests, integration tests, and e2e tests as specified
```

#### Update Progress:
```
> Update @docs/features/[feature-name]/09-progress-tracking.md 
> to reflect that we've started implementation and mark Phase 1 as in progress
```

### 6. Git Workflow Integration:
- **Commit frequently** with descriptive messages referencing PRD sections
- **Create focused PRs** for each major component or phase
- **Link commits to GitHub issues** if using issue tracking
- **Reference PRD documents** in PR descriptions

### 7. Team Coordination:
- **Daily standups**: Reference PRD progress and blockers
- **Code reviews**: Ensure implementation matches PRD specifications
- **Stakeholder updates**: Use PRD success metrics for progress reports
- **Documentation updates**: Keep PRD current with implementation decisions

## Next Steps After Implementation Starts:
1. **Regular progress updates** using `/track-feature [feature-name]`
2. **Weekly PRD reviews** to ensure alignment with requirements
3. **Continuous testing** following the testing strategy
4. **Stakeholder demos** based on milestone completion

Begin implementation by following the Phase 1 tasks outlined in the implementation plan, ensuring all code follows the architectural decisions and requirements specified in the PRD.
