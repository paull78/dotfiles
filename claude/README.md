# Claude Code Commands

This Stow package contains custom Claude Code commands for productivity and development workflows.

## Commands Available

### `/prd [product-name]`
Generate a comprehensive Product Requirements Document with:
- Discovery phase questions
- Structured document sections
- Requirements traceability
- Stakeholder sign-off templates

### `/prd-advanced [product-name]`
Create an enterprise-ready PRD including:
- Market analysis and competitive research
- Technical architecture specifications
- Go-to-market strategy
- Risk assessment and mitigation

### `/prd-quick [product-name]`
Rapid MVP-focused PRD for startups:
- Lean startup methodology
- Problem/solution fit focus
- Core feature prioritization
- Quick iteration cycles

## Installation

If you're using Stow to manage dotfiles:

```bash
cd ~/dotfiles
stow claude
```

This will symlink the `.claude` directory to your home directory.

## Usage

After installation, start Claude Code in any directory:

```bash
claude
```

Then use the commands:
```
/prd "Mobile Task Manager App"
/prd-advanced "Enterprise CRM Platform"
/prd-quick "AI Code Formatter Tool"
```

## Customization

Feel free to modify the command templates in `.claude/commands/` to match your:
- Company's PRD format
- Specific industry requirements  
- Team workflows and processes
- Documentation standards

## Tips

- Use descriptive product names as arguments
- Commands support markdown formatting
- Generated PRDs include placeholder sections for easy completion
- All commands create structured, professional documents ready for stakeholder review
