# Claude Code Commands

This Stow package contains custom Claude Code commands for **complete feature development lifecycle** in large projects.

## Available Commands

### `/feature-prd [feature-name]`
Generate a comprehensive Product Requirements Document for major feature development.

### `/implement-feature [feature-name]`  
Start implementing a feature based on existing PRD documentation.

### `/track-feature [feature-name]`
Update feature implementation progress and track development status.

## Complete Development Workflow

### **Phase 1: Planning & PRD Creation**
```bash
cd ~/your-project
claude
/feature-prd "User Authentication System"
```

**What it creates:**
- Comprehensive PRD with 9 documents in `docs/features/user-authentication-system/`
- Technical architecture, API specs, database design
- Implementation phases, testing strategy, success metrics
- Progress tracking template for ongoing development

### **Phase 2: Development Setup**
```bash
# Exit Claude Code
git checkout -b feature/user-authentication-system

# Optional: Create GitHub issue
gh issue create --title "User Authentication System" \
  --body "Implementation plan: docs/features/user-authentication-system/README.md"

# Start implementation
claude
/implement-feature "user-authentication-system"
```

**What it does:**
- Loads all PRD documentation into context
- Guides you through Phase 1 implementation
- Provides specific commands for database, API, frontend work
- Sets up proper git workflow and team coordination

### **Phase 3: Development & Progress Tracking**
```bash
# During development (weekly/as needed)
claude
/track-feature "user-authentication-system"

# For specific implementation tasks
> Based on @docs/features/user-authentication-system/04-api-specification.md,
> implement the login endpoint following our existing API patterns

> Update @docs/features/user-authentication-system/09-progress-tracking.md
> to mark Phase 1: Database Setup as completed
```

**What it tracks:**
- Phase completion status with dates
- Implementation decisions and changes
- Timeline adherence and adjustments
- Test coverage and quality metrics

## Generated Documentation Structure

```
docs/features/[feature-name]/
├── README.md                           # Feature overview & navigation
├── 01-requirements.md                  # Detailed functional & non-functional requirements
├── 02-technical-architecture.md        # System design & architecture patterns
├── 03-implementation-plan.md           # Development phases & task breakdown
├── 04-api-specification.md             # API design & endpoint specifications
├── 05-database-design.md               # Schema changes & migration plans
├── 06-testing-strategy.md              # QA plan & comprehensive test cases
├── 07-deployment-plan.md               # Release strategy & rollout plan
├── 08-success-metrics.md               # KPIs & measurement framework
├── 09-progress-tracking.md             # Implementation progress & updates ⭐ NEW
└── assets/                             # Diagrams, wireframes, mockups
    ├── architecture-diagram.md         # Mermaid system diagrams
    ├── user-flow-diagram.md            # User journey flows
    └── database-schema.md              # ERD diagrams
```

## Key Workflow Benefits

### **🔄 Living Documentation**
- PRD stays current with implementation reality
- Progress tracking shows real status, not just estimates
- Implementation decisions are documented as they happen

### **🤝 Team Coordination**
- Clear phase-based development with measurable milestones
- Stakeholder updates based on concrete progress metrics
- Code reviews reference specific PRD requirements

### **⚡ Claude Code Integration**
- Commands automatically load relevant PRD context
- Implementation guidance based on architectural decisions
- Progress updates maintain documentation accuracy

### **📊 Professional Output**
- Enterprise-ready documentation for stakeholder review
- Realistic timelines based on project complexity analysis
- Risk assessment and mitigation strategies

## Example: Complete Authentication Feature

```bash
# 1. Create comprehensive PRD
/feature-prd "User Authentication System"

# 2. Review and refine (still in Claude Code)
> Update the timeline in @docs/features/user-authentication-system/03-implementation-plan.md 
> based on our team of 3 engineers and 6-week deadline

# 3. Set up development
git checkout -b feature/user-authentication-system

# 4. Start implementation  
/implement-feature "user-authentication-system"

# 5. Implement Phase 1
> Based on @docs/features/user-authentication-system/05-database-design.md,
> create the user authentication database schema and migrations

# 6. Track progress
/track-feature "user-authentication-system"
> Mark Phase 1 as completed and update timeline for Phase 2

# 7. Continue development with full PRD context
> Implement the JWT authentication endpoints as specified in 
> @docs/features/user-authentication-system/04-api-specification.md
```

## Installation

```bash
cd ~/dotfiles
stow claude
```

## Best Practices

### **Always start from project root**
```bash
cd ~/your-project  # Important for context analysis
claude
```

### **Use descriptive feature names**
- ✅ "User Authentication System"
- ✅ "Advanced Search & Filtering"  
- ❌ "Auth" or "Search"

### **Follow the phase-based approach**
1. Complete PRD planning first
2. Get stakeholder sign-off
3. Set up git workflow
4. Implement phase by phase
5. Track progress regularly

### **Keep documentation current**
- Update progress tracking weekly
- Document implementation decisions
- Revise timelines based on actual progress
- Add lessons learned for future features

## Use Cases

✅ **Perfect for:**
- Major feature additions (4+ weeks development)
- Cross-team coordination requirements
- Complex integration with existing systems
- Professional development environments
- Features requiring stakeholder oversight

❌ **Overkill for:**
- Bug fixes or minor improvements
- Simple UI changes
- Quick experiments or prototypes
- Solo developer side projects
