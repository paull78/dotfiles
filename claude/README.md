# Claude Code Commands

This Stow package contains custom Claude Code commands for productivity and development workflows.

## Available Command

### `/feature-prd [feature-name]`
Generate a comprehensive Product Requirements Document for **major feature development** in existing large projects.

**Designed for:**
- Long-running feature development (weeks to months)
- Complex integration with existing codebase
- Large-scale projects requiring detailed planning
- Cross-team coordination (engineering, design, PM, QA)
- Professional software development environments

**Key Features:**
- **Project-aware**: Analyzes existing codebase and documentation
- **Comprehensive scope**: Covers requirements, architecture, implementation, testing
- **Organized structure**: Creates `docs/features/[feature-name]/` with 8+ documents
- **Professional output**: Ready for stakeholder review and team coordination
- **Actionable planning**: Includes timelines, resource allocation, risk assessment

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
└── assets/                             # Diagrams, wireframes, mockups
    ├── architecture-diagram.md         # Mermaid system diagrams
    ├── user-flow-diagram.md            # User journey flows
    └── database-schema.md              # ERD diagrams
```

## Installation

Using Stow to manage dotfiles:

```bash
cd ~/dotfiles
stow claude
```

This symlinks `.claude/commands/` to `~/.claude/commands/`.

## Usage

**Always run from your project root** for best context analysis:

```bash
# Navigate to project root
cd ~/my-large-project

# Start Claude Code
claude

# Generate comprehensive feature PRD
/feature-prd "User Authentication System"
/feature-prd "Advanced Search & Filtering"
/feature-prd "Real-time Collaboration Features"
```

## What Makes This Command Special

### **Project Context Analysis**
- Automatically scans existing documentation
- Identifies current architecture patterns
- Finds integration points with existing features
- Analyzes tech stack and dependencies

### **Comprehensive Planning**
- **8 detailed documents** covering all aspects of feature development
- **Risk assessment** with mitigation strategies
- **Resource planning** with realistic timeline estimates
- **Success metrics** and measurement plans

### **Professional Output**
- Cross-referenced documentation with clear navigation
- Mermaid diagrams for architecture and user flows
- Actionable checklists for development phases
- Stakeholder sign-off sections
- Templates for ongoing tracking

### **Integration-Focused**
- Considers impact on existing codebase
- Plans database migrations and API changes
- Addresses backwards compatibility
- Includes deployment and rollout strategy

## Example Output

For `/feature-prd "Advanced Search"`, you'll get:
- **60+ pages** of comprehensive documentation
- **Detailed technical specifications** ready for implementation
- **Timeline estimates** for realistic project planning  
- **Risk analysis** to avoid common pitfalls
- **Success metrics** to measure feature impact

## Use Cases

✅ **Perfect for:**
- Major feature additions (search, auth, payments, etc.)
- Cross-team initiatives requiring coordination
- Features with complex technical requirements
- Long-term development projects (4+ weeks)
- Professional development environments

❌ **Not ideal for:**
- Quick bug fixes or minor improvements
- Simple UI changes
- Proof-of-concept or experimental features
- Single-developer side projects

## Customization

Modify `feature-prd.md` to match your:
- Company's PRD templates and standards
- Specific documentation requirements
- Development workflow processes
- Stakeholder review procedures
