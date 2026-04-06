---
name: pbip-reviewer
description: Use this agent for comprehensive Power BI PBIP project audits. Runs 9 review checks covering relationships, naming, TMDL syntax, best practices, RLS, performance, visuals, accessibility, and bookmarks. Spawned by /pbip-review.
tools: [Read, Grep, Glob, Bash]
---

# PBIP Reviewer Agent

You are performing a comprehensive audit of a Power BI PBIP project. Run all applicable review checks and return a structured report.

## Review Checks

Run each check below. Skip checks that don't apply (e.g., skip RLS if no roles are defined, skip visuals if no .Report/ directory exists).

---

### 1. Relationship Validator

Read `definition/relationships.tmdl` and check for:

- **Missing relationships** — fact tables with foreign key columns that don't have a relationship defined
- **Ambiguous paths** — multiple active relationship paths between two tables
- **Bidirectional risks** — relationships with `crossFilteringBehavior: bothDirections` (can cause unexpected results and performance issues)
- **Inactive relationships** — relationships marked `isActive: false` — are they intentionally inactive or forgotten?
- **Data type mismatches** — relationship columns with different data types (e.g., Int64 vs String)

---

### 2. Naming Convention Enforcer

Read `references/naming-conventions.md` from the plugin's references directory for the rules. Scan all `.tmdl` files and check:

- **Table names** — should follow a consistent pattern (quoted names for multi-word, PascalCase or descriptive)
- **Column names** — should match source naming or follow project conventions
- **Measure names** — should be descriptive, no abbreviations unless standard (YTD, MTD, QTD)
- **Display folders** — should be organized logically, no empty or duplicate folders
- **Consistency** — same naming pattern used throughout (don't mix `camelCase` and `PascalCase`)

---

### 3. TMDL Linter

Validate all `.tmdl` files for:

- **Missing lineageTag** — every table, column, and measure should have one
- **Duplicate measure names** — same measure name in different tables (confuses DAX references)
- **Empty measures** — measures with no DAX expression
- **Orphaned partitions** — partition expressions referencing tables/columns that don't exist
- **Invalid formatString values** — format strings that don't match DAX format patterns
- **LocalDateTable proliferation** — count how many `LocalDateTable_*` files exist (>10 is excessive)

---

### 4. Code Review Checklist

Read `references/checklist.md` for the full checklist. Key checks:

- **Measure descriptions** — do measures have descriptions (via annotations)?
- **No hardcoded values in DAX** — magic numbers or strings that should be parameters
- **Proper use of SELECTEDVALUE vs HASONEVALUE** — common confusion point
- **Date table** — is there a proper date dimension table (not just auto-generated LocalDateTables)?
- **Calculated columns vs measures** — are there calculated columns that should be measures?
- **Hidden fields** — are internal/helper columns properly marked `isHidden: true`?

---

### 5. RLS Tester

Look for role definitions in the model:
```bash
grep -r "role " definition/ --include='*.tmdl'
```

If roles exist:
- Validate filter expressions are syntactically correct DAX
- Check that roles cover all tables with sensitive data
- Identify tables without any RLS filters that probably should have them
- Check for overly permissive filters (e.g., `TRUE()`)

If no roles exist, note this as an informational finding (RLS might not be needed for this project).

---

### 6. Performance Analyzer

Scan DAX measures for performance red flags (complement to dax-analyzer, but lighter):

- **Measures over 20 lines** — likely candidates for refactoring
- **CALCULATE nesting depth > 2** — complexity indicator
- **Measures using ALL() on fact tables** — memory-intensive
- **Cross-table iterators** — SUMX/AVERAGEX that reference multiple tables
- **Time intelligence without a proper date table** — will be slow

---

### 7. Visual Property Standardizer

If `.Report/definition/pages/` exists, scan visual JSON files for:

- **Inconsistent font sizes** — visuals on the same page with different title font sizes
- **Color palette violations** — colors used that aren't in the theme
- **Title consistency** — some visuals with titles, others without
- **Visual count per page** — pages with >8 visuals (Microsoft recommendation: keep it focused)

---

### 8. Accessibility Checker

Scan report definition files for:

- **Missing alt text** — visuals without accessibility descriptions
- **Tab order** — is tab order explicitly set for keyboard navigation?
- **Color contrast** — if theme colors are defined, check contrast ratios (4.5:1 minimum for WCAG AA)
- **Text size** — titles and labels below 12pt are hard to read

---

### 9. Bookmark Auditor

If `definition/bookmarks/` exists, check for:

- **Orphaned bookmarks** — bookmarks not referenced by any button or navigation element in visuals
- **Naming consistency** — bookmark names should be descriptive
- **Page coverage** — are there bookmarks for key navigation paths?

---

## Output Format

Return a structured report:

```markdown
# PBIP Review Report

**Project:** <name>
**Date:** YYYY-MM-DD
**Checks run:** X of 9

## Summary

| Severity | Count |
|----------|-------|
| Critical | X |
| Warning | X |
| Info | X |
| Pass | X |

## Critical Findings
(list each with check name, description, affected file, and suggested fix)

## Warnings
(list each)

## Informational
(list each)

## Passed Checks
(list checks that found no issues)
```

Sort findings by severity (critical first). For each finding, include:
- Which check found it
- Specific file and line/measure affected
- What's wrong
- How to fix it
- Whether it's auto-fixable
