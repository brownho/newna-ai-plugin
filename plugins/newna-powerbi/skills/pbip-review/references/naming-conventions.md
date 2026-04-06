# Naming Conventions for PBIP Projects

Rules for the naming convention enforcer check in pbip-reviewer.

## Tables

| Pattern | Rule | Example |
|---------|------|---------|
| Dimension tables | Descriptive noun, singular | `Customer`, `Date`, `Product` |
| Fact tables | Descriptive noun, can be plural | `Sales`, `Orders`, `Cases` |
| Measure-only tables | Descriptive with "Measures" suffix | `Kite Measures`, `Financial Measures` |
| Bridge tables | Prefix with "Bridge" | `Bridge Customer Product` |
| Auto-generated | Skip in review | `LocalDateTable_*`, `DateTableTemplate_*` |

**Violations:**
- Table names with underscores when not from a source system (e.g., `sales_data` → `Sales Data`)
- Abbreviations without context (e.g., `Cust` → `Customer`)
- Inconsistent casing across tables

## Columns

| Pattern | Rule | Example |
|---------|------|---------|
| Standard columns | Match source naming or descriptive | `Revenue`, `Customer Name` |
| Foreign keys | Match the dimension's primary key name | `CustomerID` in both fact and dim |
| Hidden helper columns | Mark `isHidden: true` | Sort columns, key columns not shown to users |
| Calculated columns | Prefix with `_` if internal | `_SortOrder`, `_FullName` |

**Violations:**
- Columns with trailing spaces
- Columns with source system prefixes that add no value (e.g., `SF_AccountName__c` — consider renaming in the model)

## Measures

| Pattern | Rule | Example |
|---------|------|---------|
| Aggregations | Verb + noun | `Total Revenue`, `Count of Orders` |
| Ratios/percentages | Noun + qualifier | `Revenue Growth %`, `Win Rate` |
| Time intelligence | Base + time qualifier | `Revenue YTD`, `Revenue MTD`, `Revenue PY` |
| Conditional | Descriptive of condition | `Revenue (Active Customers Only)` |

**Standard abbreviations (OK to use):**
- YTD (Year to Date), MTD (Month to Date), QTD (Quarter to Date)
- PY (Prior Year), PM (Prior Month), PQ (Prior Quarter)
- vs (versus), % (percentage)

**Violations:**
- Generic names: `Measure 1`, `Test`, `Temp`, `New Measure`
- Abbreviations without context: `Rev`, `Cnt`, `Amt` (prefer `Revenue`, `Count`, `Amount`)
- Inconsistent qualifiers: mixing `YTD` and `Year To Date` in the same model

## Display Folders

- Organize measures by business domain (e.g., `Financial`, `Operations`, `HR`)
- Use consistent folder naming (don't mix `Sales` and `sales`)
- Every measure should be in a folder (no root-level measures in large models)
- Avoid deeply nested folders (max 2 levels)

## General Rules

- Be consistent — the most important rule. Pick a convention and stick to it.
- Match the audience — if business users see these names, use business language, not technical jargon.
- Avoid special characters — `#`, `@`, `&` in names can cause issues in some contexts.
