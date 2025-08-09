---
description: Generate comprehensive PRD for major feature development in existing projects
allowed-tools: Edit, Write, Bash(find:*), Bash(grep:*)
---

# Feature Development PRD Generator

Create a detailed PRD for major feature: $ARGUMENTS

## Context Analysis First:
!`find . -name "README.md" -o -name "package.json" -o -name "*.md" | head -5`
!`find . -name "docs" -type d | head -3`
!`grep -r "TODO\|FIXME\|Feature" --include="*.md" . | head -3`
!`git branch --show-current`

## Project Integration:
- Review existing documentation: @README.md
- Check current architecture patterns in codebase
- Identify integration points with existing features
- Analyze current tech stack and dependencies

## Comprehensive Feature PRD Structure:

### 1. Feature Overview & Context
- **Feature Name & Description**
- **Business Justification** (why this feature, why now)
- **Relationship to existing codebase** and features
- **Strategic alignment** with product roadmap
- **Stakeholder identification** (PM, engineering, design, QA)

### 2. Detailed Requirements Analysis
- **Functional Requirements** (what the feature must do)
- **Non-Functional Requirements** (performance, security, scalability)
- **Integration Requirements** (APIs, databases, external services)
- **Data Requirements** (new models, migrations, storage)
- **UI/UX Requirements** (design system compliance, accessibility)

### 3. Technical Architecture & Implementation
- **System Architecture** (components, services, data flow)
- **Database Schema Changes** (migrations, new tables, indexes)
- **API Design** (new endpoints, modifications to existing ones)
- **Frontend Architecture** (components, state management, routing)
- **Backend Architecture** (services, business logic, middleware)
- **Third-party Integrations** (external APIs, services)

### 4. Development Planning
- **Feature Breakdown** (epics → stories → tasks)
- **Implementation Phases** (incremental delivery plan)
- **Dependencies & Blockers** (what needs to happen first)
- **Testing Strategy** (unit, integration, e2e, manual testing)
- **Code Review Process** (review criteria, approval flow)

### 5. Risk Assessment & Mitigation
- **Technical Risks** (complexity, performance, compatibility)
- **Business Risks** (market timing, user adoption, competition)
- **Resource Risks** (team capacity, skill gaps, timeline)
- **Mitigation Strategies** for each identified risk
- **Contingency Plans** (fallback options, scope reduction)

### 6. Success Metrics & Validation
- **Primary Success Metrics** (KPIs, business metrics)
- **Technical Metrics** (performance benchmarks, error rates)
- **User Experience Metrics** (adoption, engagement, satisfaction)
- **Measurement Plan** (analytics setup, A/B testing)
- **Success Criteria** (what constitutes launch readiness)

### 7. Timeline & Resource Planning
- **Development Phases** with milestones and deliverables
- **Resource Allocation** (frontend, backend, design, QA)
- **Critical Path Analysis** (longest sequence of dependent tasks)
- **Timeline Estimates** (optimistic, realistic, pessimistic)
- **Delivery Schedule** (dev, staging, production deployments)

### 8. Documentation & Communication
- **Technical Documentation** (architecture docs, API specs)
- **User Documentation** (help docs, tutorials, changelog)
- **Team Communication** (standups, reviews, demos)
- **Stakeholder Updates** (progress reports, milestone demos)

## File Organization:
Create organized documentation in: `docs/features/[feature-name]/`

```
docs/features/[feature-name]/
├── README.md                           # Feature overview & navigation
├── 01-requirements.md                  # Detailed requirements
├── 02-technical-architecture.md        # System design & architecture  
├── 03-implementation-plan.md           # Development phases & tasks
├── 04-api-specification.md             # API design & endpoints
├── 05-database-design.md               # Schema changes & migrations
├── 06-testing-strategy.md              # QA plan & test cases
├── 07-deployment-plan.md               # Release & rollout strategy
├── 08-success-metrics.md               # KPIs & measurement plan
├── 09-progress-tracking.md             # Implementation progress & updates
└── assets/                             # Diagrams, wireframes, mockups
    ├── architecture-diagram.md         # Mermaid system diagrams
    ├── user-flow-diagram.md            # User journey flows
    └── database-schema.md              # ERD diagrams
```

## Implementation Workflow Guide:

### Phase 1: PRD Creation & Review
1. **Generate comprehensive PRD** (this command)
2. **Review with stakeholders** (PM, tech lead, design)
3. **Refine requirements** based on feedback
4. **Get stakeholder sign-off** on scope and timeline

### Phase 2: Development Setup
1. **Create feature branch**: `git checkout -b feature/[feature-name]`
2. **Create GitHub issue/epic** linking to PRD
3. **Set up project tracking** (Jira tickets, GitHub projects)
4. **Schedule kickoff meeting** with development team

### Phase 3: Implementation
1. **Reference PRD documents** during development
2. **Update progress tracking** as phases complete
3. **Regular check-ins** against success metrics
4. **Document implementation decisions** and changes

### Phase 4: Testing & Deployment
1. **Execute testing strategy** as defined in PRD
2. **Follow deployment plan** for gradual rollout
3. **Monitor success metrics** post-launch
4. **Retrospective and lessons learned**

## Claude Code Integration Commands:

### For Implementation:
```
> Read the implementation plan: @docs/features/[feature-name]/03-implementation-plan.md
> Let's implement Phase 1 as described in the technical architecture: @docs/features/[feature-name]/02-technical-architecture.md
> Update the progress tracking: @docs/features/[feature-name]/09-progress-tracking.md
```

### For Progress Updates:
```
> Mark Phase 1 as completed in @docs/features/[feature-name]/09-progress-tracking.md
> Update the implementation plan with what we actually built
> Add notes about implementation decisions and changes
```

### For Testing:
```
> Implement the test cases defined in @docs/features/[feature-name]/06-testing-strategy.md
> Update test coverage and mark completed test scenarios
```

## Output Requirements:
- **Create comprehensive, interconnected documentation**
- **Include progress tracking template** with checkboxes
- **Add implementation workflow guide**
- **Include mermaid diagrams** for architecture and flows
- **Add actionable checklists** for each development phase
- **Include cross-references** between documents
- **Provide realistic estimates** based on project complexity
- **Add placeholder sections** for stakeholder sign-offs
- **Create templates** for ongoing tracking and updates
- **Include Claude Code reference commands** for implementation

Generate professional, detailed documentation that serves as both planning document and implementation guide, with clear workflows for using Claude Code throughout the development process.
