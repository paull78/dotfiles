# Claude Code Commands

This Stow package contains custom Claude Code commands for productivity and development workflows.

## Commands Available

### `/prd [product-name]`
Generate a comprehensive Product Requirements Document with **explicit file organization**:
- Creates files in current working directory
- Uses clear naming: `PRD-[product-name].md`, `[product-name]-user-stories.md`
- Includes requirements traceability matrix
- Structured for stakeholder review

### `/prd-advanced [product-name]`  
Create an enterprise-ready PRD with **organized docs structure**:
- Creates `docs/prd/` folder structure
- Separates technical specs, user research, requirements
- Includes market analysis and go-to-market strategy
- Professional documentation organization

### `/prd-smart [product-name]`
**Project-aware** PRD generation with intelligent file placement:
- Detects project context (root, docs/, other)
- Creates appropriate folder structure
- Scales with project complexity
- Smart organization based on current directory

### `/prd-quick [product-name]`
Rapid MVP-focused PRD for startups:
- Single file in current directory
- Lean startup methodology
- Quick iteration focus

## File Creation Behavior

**Important**: Files are created in your **current working directory** where you run `claude`, NOT in the `.claude` folder.

### Examples:
```bash
# In project root
cd ~/my-app
claude
/prd "Mobile App"
# Creates: PRD-mobile-app.md (in ~/my-app/)

# In project docs folder  
cd ~/my-app/docs
claude
/prd-advanced "Enterprise Tool"
# Creates: prd/enterprise-tool/ (in ~/my-app/docs/)

# Smart organization
cd ~/my-project
claude  
/prd-smart "New Feature"
# Creates: docs/product-requirements/new-feature/ (detected project root)
```

## Installation

Using Stow to manage dotfiles:

```bash
cd ~/dotfiles
stow claude
```

This symlinks `.claude/commands/` to `~/.claude/commands/`.

## Usage Tips

- **Run from appropriate directory**: Files save where you launch `claude`
- **Use descriptive names**: `"AI Code Formatter Tool"` becomes `ai-code-formatter-tool`
- **Organize by project**: Use `/prd-smart` for automatic project-aware organization
- **Start simple**: Use `/prd-quick` for rapid prototyping, upgrade to `/prd-advanced` later

## File Structure Examples

### Basic PRD (`/prd`)
```
current-directory/
├── PRD-product-name.md
├── product-name-user-stories.md
└── product-name-requirements-matrix.md
```

### Advanced PRD (`/prd-advanced`)
```
docs/prd/
├── product-name-prd.md
├── product-name-technical-spec.md
├── product-name-user-research.md
├── product-name-requirements.md
└── assets/
```

### Smart PRD (`/prd-smart`)
```
docs/product-requirements/product-name/
├── README.md
├── prd-main.md
├── user-stories.md
├── technical-requirements.md
├── success-metrics.md
└── timeline-roadmap.md
```

## Customization

Modify commands in `.claude/commands/` to match your:
- Company PRD templates
- File naming conventions
- Directory structure preferences
- Documentation standards
