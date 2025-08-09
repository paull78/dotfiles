---
description: Continue implementing feature from task list (auto-marks completed tasks)
allowed-tools: Edit, Write, Bash(find:*), Bash(git:*)
---

# Feature Implementation Controller

Continue implementing feature: $ARGUMENTS

## Find Feature Documentation:
!`find docs/features -name "*$ARGUMENTS*" -type d | head -1`
!`git branch --show-current`

## Load Feature Context:
- Load feature overview: @docs/features/[feature-name]/README.md
- Load current task list: @docs/features/[feature-name]/TASKS.md
- Load technical details: @docs/features/[feature-name]/ARCHITECTURE.md

## Branch Verification:
1. **Check current branch** against the branch specified in PRD
2. **If on wrong branch**: 
   - Show the correct branch name from PRD
   - Ask user to switch: `git checkout [correct-branch-name]` 
   - Stop and ask user to run command again after switching
3. **If on correct branch**: Proceed with implementation

## Task Execution:

### Find Next Task:
- Identify the **next unchecked task** in TASKS.md
- If no next task is clearly marked, find the first unchecked item
- Load relevant context for this specific task

### Implement Current Task:
- **Execute the task** according to the architecture and requirements
- **Follow existing code patterns** in the project
- **Write complete, working code** for the task
- **Include appropriate tests** if the task requires them

### Auto-Complete Task:
After successfully implementing the task:
1. **Mark task as done**: Change `- [ ]` to `- [x]` in TASKS.md
2. **Add completion note**: Add date and any important notes
3. **Update "Next Task"**: Point to the next unchecked item
4. **Save progress**: Update the task list file

## Implementation Flow:

### For Backend Tasks:
```
> Implement the next backend task from @docs/features/[feature-name]/TASKS.md
> Follow the architecture specified in @docs/features/[feature-name]/ARCHITECTURE.md
> After completing, mark the task as done and point to next task
```

### For Frontend Tasks:
```
> Implement the next frontend task from @docs/features/[feature-name]/TASKS.md
> Use existing component patterns and styling from the codebase
> After completing, update the task list and identify next steps
```

### For Database Tasks:
```
> Implement the next database task from @docs/features/[feature-name]/TASKS.md
> Follow existing migration and model patterns in the project
> After completing, mark as done and update task status
```

## Task Completion Process:

### 1. Execute Task
- Implement the specific functionality
- Write necessary code files
- Add tests if required
- Follow project conventions

### 2. Mark Complete
- Update TASKS.md: `- [ ] TaskName` → `- [x] TaskName ✅ [Date]`
- Add brief completion note if needed
- Update "Next Task" pointer

### 3. Prepare for Next
- Identify what the next unchecked task is
- Note any dependencies or preparation needed
- Update the "Next Task" section in TASKS.md

## Example Task Updates:

### Before:
```markdown
- [ ] 3. Create UserService for business logic
- [ ] 4. Implement API endpoints: /auth/login, /auth/register

**Next Task**: Task 3 - Create UserService
```

### After completing Task 3:
```markdown
- [x] 3. Create UserService for business logic ✅ 2025-08-09
- [ ] 4. Implement API endpoints: /auth/login, /auth/register

**Next Task**: Task 4 - Implement API endpoints
```

## Resumption Logic:
- **Always check branch first** - don't start work on wrong branch
- **Find the actual next task** from the task list
- **Load all relevant context** for that specific task
- **Execute completely** - don't stop halfway
- **Mark as done** - maintain accurate progress tracking
- **Point to next** - make resumption easy

Continue implementing the next task in the feature development, ensuring branch correctness and automatic progress tracking.
