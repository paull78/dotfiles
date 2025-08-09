---
description: Update feature implementation progress and track development status
allowed-tools: Edit, Write, Bash(find:*)
---

# Feature Implementation Tracker

Update implementation progress for feature: $ARGUMENTS

## Find Feature Documentation:
!`find docs/features -name "*$ARGUMENTS*" -type d | head -3`

## Implementation Status Update:

### Current Phase Analysis:
- Review progress tracking: @docs/features/[feature-name]/09-progress-tracking.md
- Check implementation plan: @docs/features/[feature-name]/03-implementation-plan.md
- Verify against requirements: @docs/features/[feature-name]/01-requirements.md

### Progress Update Tasks:
1. **Update Progress Tracking Document**
   - Mark completed phases/tasks with ✅
   - Add completion dates and notes
   - Update percentage complete
   - Note any blockers or issues

2. **Document Implementation Decisions**
   - Record any deviations from original plan
   - Add technical decisions made during development
   - Update architecture if changes were needed
   - Note lessons learned

3. **Update Timeline & Estimates**
   - Revise remaining timeline based on actual progress
   - Update resource allocation if needed
   - Identify new risks or dependencies

4. **Test Coverage Tracking**
   - Update testing strategy with completed tests
   - Mark test scenarios as passed/failed
   - Add new test cases discovered during development

### Status Report Generation:
Create a brief status update including:
- **Phase completion status** (what's done, what's in progress)
- **Timeline adherence** (on track, ahead, behind schedule)
- **Key achievements** this week/sprint
- **Blockers and dependencies** requiring attention
- **Next milestone** and expected completion

### Integration with Git Workflow:
- **Commit references**: Link commits to specific PRD tasks
- **Branch progress**: Track feature branch development
- **PR reviews**: Ensure PRs reference PRD requirements
- **Merge readiness**: Check against acceptance criteria

## Commands for Common Updates:

### Mark Phase Complete:
```
> Update @docs/features/[feature-name]/09-progress-tracking.md to mark Phase 1: Database Setup as completed
> Add completion date and any notes about implementation differences
```

### Add Implementation Notes:
```
> Add a section to @docs/features/[feature-name]/09-progress-tracking.md documenting 
> the decision to use JWT tokens instead of session-based auth, including rationale
```

### Update Timeline:
```
> Based on current progress, update the timeline in @docs/features/[feature-name]/03-implementation-plan.md
> Adjust Phase 2 start date and revise overall completion estimate
```

### Test Progress:
```
> Update @docs/features/[feature-name]/06-testing-strategy.md to mark unit tests as completed
> Add notes about test coverage percentage and any gaps found
```

Update all relevant documentation to maintain accurate project tracking and team visibility.
