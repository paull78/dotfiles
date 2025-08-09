---
description: Generate PRD with organized docs folder structure
---

# Advanced PRD Generator with Docs Organization

Create a detailed PRD for: $ARGUMENTS

## File Structure Creation:
First, create a `docs/prd/` directory structure, then generate:

```
docs/
└── prd/
    ├── [product-name]-prd.md           # Main PRD
    ├── [product-name]-technical-spec.md # Technical details
    ├── [product-name]-user-research.md  # User personas & research
    ├── [product-name]-requirements.md   # Detailed requirements
    └── assets/                         # Diagrams, wireframes
```

## PRD Components:
1. **Executive Summary** (1-page overview)
2. **Market Analysis** (competitive landscape)
3. **User Research** (personas, user journeys)
4. **Product Strategy** (vision, positioning)
5. **Functional Requirements** (features, user stories)
6. **Technical Requirements** (architecture, APIs)
7. **Design Requirements** (UI/UX guidelines)
8. **Success Metrics** (KPIs, analytics)
9. **Implementation Plan** (phases, timeline)
10. **Risk Assessment** (technical, market, resource risks)

## Instructions:
1. **Create directory structure** first: `mkdir -p docs/prd/assets`
2. **Generate main PRD** in `docs/prd/[product-name]-prd.md`
3. **Create supporting documents** in the same folder
4. **Include cross-references** between documents
5. **Add placeholder mermaid diagrams** for workflows
6. **Create tables** for requirements tracking

Organize all documents with consistent formatting, clear navigation links between files, and actionable next steps.
