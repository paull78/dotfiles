---
description: Generate PRD with smart project-aware file organization
---

# Smart PRD Generator (Project-Aware)

Create a well-organized PRD for: $ARGUMENTS

## Smart File Organization Logic:

### If in project root (has package.json, README.md, etc.):
Create: `docs/product-requirements/[product-name]/`
- Main PRD, user stories, technical specs
- Keeps project root clean

### If in docs/ directory:
Create: `product-requirements/[product-name]/`
- Organize within existing docs structure

### If in any other directory:
Create files directly in current directory:
- `PRD-[product-name].md`
- `[product-name]-stories.md`

## Generated Structure:
```
[chosen-location]/
├── README.md                    # Overview & navigation
├── prd-main.md                 # Core PRD document  
├── user-stories.md             # Stories & acceptance criteria
├── technical-requirements.md   # Architecture & tech specs
├── success-metrics.md          # KPIs & measurement plan
└── timeline-roadmap.md         # Implementation phases
```

## PRD Content:
- **Problem Definition** (what we're solving)
- **Solution Overview** (how we'll solve it)
- **User Personas & Journeys** (who & how)
- **Feature Breakdown** (MoSCoW prioritization)
- **Technical Architecture** (system design)
- **Success Criteria** (measurable outcomes)
- **Go-to-Market Plan** (launch strategy)
- **Resource Planning** (team, timeline, budget)

## Instructions:
1. **Detect project context** and choose appropriate location
2. **Create organized folder structure** if needed  
3. **Generate comprehensive documentation** with cross-links
4. **Include actionable checklists** for each phase
5. **Add placeholder diagrams** (mermaid) for key workflows
6. **Create stakeholder sign-off sections**

Generate professional, comprehensive documentation that scales with project complexity.
