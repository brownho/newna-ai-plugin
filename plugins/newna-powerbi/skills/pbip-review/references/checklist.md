# Power BI Code Review Checklist

Comprehensive checklist for the pbip-reviewer agent. Each item is a yes/no check.

## Data Model

- [ ] **Star schema** — fact tables connect to dimension tables, not to other fact tables
- [ ] **Proper date table** — dedicated date dimension (not relying on auto-generated LocalDateTables)
- [ ] **Date table marked** — the date table is marked as a date table in the model
- [ ] **No circular dependencies** — no measure references that create circular loops
- [ ] **Referential integrity** — relationship columns have matching values (no orphaned foreign keys)
- [ ] **Appropriate cardinality** — relationships use the correct cardinality (one-to-many preferred)
- [ ] **Single active path** — only one active relationship path between any two tables

## Measures

- [ ] **All measures have descriptions** — every measure has an annotation explaining what it calculates
- [ ] **No hardcoded values** — no magic numbers or strings in DAX (use variables or parameters)
- [ ] **DIVIDE used for division** — all division operations use DIVIDE() with a fallback
- [ ] **Variables used for readability** — complex measures use VAR/RETURN pattern
- [ ] **Measures in display folders** — all measures organized in logical folders
- [ ] **No duplicate measure names** — each measure name is unique across the model
- [ ] **Calculated columns justified** — calculated columns are only used when measures can't do the job (sort orders, row-level categorization)
- [ ] **Format strings set** — currency measures show $, percentages show %, dates are formatted

## Columns

- [ ] **Hidden helper columns** — columns used only for relationships or sorting are marked `isHidden: true`
- [ ] **Consistent data types** — relationship key columns have matching data types
- [ ] **No unnecessary columns** — columns not used in visuals, measures, or relationships are removed or hidden
- [ ] **Sort-by columns** — month names, weekday names have proper sort-by-column set

## Relationships

- [ ] **No ambiguous relationships** — every pair of tables has at most one active relationship path
- [ ] **Bidirectional justified** — bidirectional cross-filtering is only used when necessary (e.g., many-to-many)
- [ ] **Active/inactive intentional** — inactive relationships have a clear purpose (used in USERELATIONSHIP)

## Report

- [ ] **Visual count per page** — no page has more than 8-10 visuals (keeps it focused and fast)
- [ ] **Consistent formatting** — fonts, colors, and sizes are consistent across pages
- [ ] **Alt text on visuals** — accessibility descriptions for screen readers
- [ ] **Tab order set** — keyboard navigation follows a logical order
- [ ] **Bookmarks documented** — bookmarks have descriptive names and are referenced by navigation buttons

## Security

- [ ] **RLS defined** (if needed) — sensitive data has row-level security roles
- [ ] **RLS covers all sensitive tables** — no gaps in security coverage
- [ ] **No overly permissive roles** — no roles with `TRUE()` as the filter (allows everything)

## Git/Version Control

- [ ] **.gitignore includes .pbi/** — cache and local settings are not committed
- [ ] **No cache.abf in history** — sensitive data cache was never committed
- [ ] **No .platform in repo** (unless doing CI/CD) — deployment GUIDs are environment-specific
- [ ] **CHANGELOG.md maintained** — change history is documented
- [ ] **data-dictionary.md current** — dictionary matches actual model state
