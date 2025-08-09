# Claude Code Commands

Simple, focused commands for **solo feature development** in existing projects.

## Available Commands

### `/plan-feature [feature-name]`
Create PRD and ordered task list for a new feature.

### `/work-feature [feature-name]`  
Continue implementing from task list, auto-marking tasks as completed.

## Simple Solo Development Workflow

### **Step 1: Plan Your Feature**
```bash
cd ~/your-project
claude
/plan-feature "User Authentication"
```

**What happens:**
- Analyzes your existing codebase
- **Asks for branch name** (e.g., `feature/user-auth`)
- Creates focused PRD in `docs/features/user-authentication/`
- **Generates ordered task list** with 15-20 specific, actionable tasks
- Records branch name in documentation

### **Step 2: Start Implementation**
```bash
# Create the branch (when you specified in planning)
git checkout -b feature/user-auth

# Start working through tasks
claude
/work-feature "user-authentication"
```

**What happens:**
- **Verifies you're on correct branch** (stops if not)
- Finds next unchecked task from task list
- Implements the task completely
- **Auto-marks task as done** ✅
- Points to next task for easy resumption

### **Step 3: Resume Development (anytime)**
```bash
# Continue where you left off
claude
/work-feature "user-authentication"
```

**Always:**
- Checks branch correctness first
- Finds next unchecked task automatically
- Implements completely and marks done
- Makes resumption effortless

## Generated Structure

```
docs/features/user-authentication/
├── README.md          # Feature overview & requirements
├── TASKS.md           # ✅ Ordered task list with auto-completion
└── ARCHITECTURE.md    # Technical implementation details
```

## Task List Example

```markdown
# Implementation Tasks for User Authentication

**Branch**: feature/user-auth
**Status**: In Progress

## Database & Backend Tasks
- [x] 1. Create user table migration ✅ 2025-08-09
- [x] 2. Implement User model with validations ✅ 2025-08-09  
- [ ] 3. Create AuthService for JWT handling
- [ ] 4. Implement /auth/login and /auth/register endpoints
- [ ] 5. Add password hashing and validation

## Frontend Tasks
- [ ] 6. Create LoginForm component
- [ ] 7. Create RegisterForm component
- [ ] 8. Add authentication state management
- [ ] 9. Implement protected route wrapper

**Next Task**: Task 3 - Create AuthService for JWT handling
```

## Key Benefits for Solo Development

### **🎯 Focused Planning**
- No timeline estimation overhead
- No team coordination complexity
- Just: requirements → architecture → tasks

### **⚡ Effortless Resumption**
- Always knows exactly what to do next
- Auto-marks completed work
- Never lose progress or forget where you were

### **🔒 Branch Safety**
- Enforces correct branch before starting work
- Prevents accidental commits to wrong branch
- Keeps feature development isolated

### **📋 Task-Driven Development**
- Breaks complex features into bite-sized tasks
- Each task completable in one session
- Clear progress visibility

## Example: Complete Auth Feature

```bash
# 1. Plan the feature
cd ~/my-app
claude
/plan-feature "User Authentication"
# → Asks for branch name: "feature/user-auth"
# → Creates PRD + 16 ordered tasks

# 2. Start development
git checkout -b feature/user-auth
claude
/work-feature "user-authentication"
# → Implements Task 1: Create user table migration
# → Auto-marks as done ✅
# → Points to Task 2

# 3. Continue next day
claude
/work-feature "user-authentication"  
# → Checks branch ✅
# → Finds Task 2: Implement User model
# → Implements and marks done ✅

# 4. Resume after break
claude
/work-feature "user-authentication"
# → Always picks up exactly where you left off
```

## Installation

```bash
cd ~/dotfiles
stow claude
```

## Perfect For

✅ **Solo developers** working on personal or small projects  
✅ **Complex features** that need breaking down into manageable tasks  
✅ **Resumable development** across multiple sessions  
✅ **Branch-based workflows** with proper isolation  
✅ **Existing projects** requiring integration planning  

## Not Suitable For

❌ Team coordination and collaboration  
❌ Timeline estimation and project management  
❌ Simple bug fixes (overkill)  
❌ Experimental prototyping  

Keep it simple, stay focused, get features done. 🚀
