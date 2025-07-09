# NEXUS Coding Templates

This directory contains language-specific coding standards, project structures, and TDD patterns that complement the language-agnostic NEXUS commands.

## Available Templates

- **`go-coding-standards.md`** - Go-specific TDD patterns, project structure, and best practices
- **`python-coding-standards.md`** - Python-specific TDD patterns, project structure, and best practices

## Usage

These templates are referenced by the NEXUS commands when language-specific guidance is needed:

- The `04-code_creator.md` command references these templates for project structure and coding patterns
- Each template provides concrete examples that complement the universal TDD methodology
- Templates include testing frameworks, dependency injection patterns, and code quality tools

## Adding New Languages

To add support for a new language:

1. Create `{language}-coding-standards.md` 
2. Follow the existing template structure:
   - Project Structure
   - Testing Patterns  
   - TDD Patterns
   - Code Quality

The goal is to provide concrete, actionable guidance while keeping the core NEXUS commands language-agnostic.