# DAX Anti-Patterns Reference

Common DAX anti-patterns and their fixes for the pbip-reviewer agent.

## Critical Patterns

### Division without DIVIDE
```dax
// Anti-pattern: division by zero risk
[Revenue] / [Count]

// Fix: use DIVIDE with fallback
DIVIDE([Revenue], [Count], 0)
```
**Why:** Division by zero produces an error. DIVIDE handles it gracefully.

### FILTER on fact tables
```dax
// Anti-pattern: iterates entire fact table
CALCULATE(SUM(Sales[Amount]), FILTER(Sales, Sales[Year] = 2024))

// Fix: direct filter predicate
CALCULATE(SUM(Sales[Amount]), Sales[Year] = 2024)
```
**Why:** FILTER materializes the entire table in memory. Direct predicates let the engine optimize.

### FILTER + VALUES when unnecessary
```dax
// Anti-pattern: verbose and slower
CALCULATE([Measure], FILTER(VALUES(Dim[Col]), Dim[Col] = "X"))

// Fix: direct predicate
CALCULATE([Measure], Dim[Col] = "X")
```
**Why:** VALUES + FILTER is only needed for complex predicates that can't be expressed as simple equality/comparison.

## Warning Patterns

### Deeply nested CALCULATE (>2 levels)
```dax
// Anti-pattern: hard to read and maintain
CALCULATE(
    CALCULATE(
        CALCULATE(SUM(Sales[Amount]), ...),
        ...
    ),
    ...
)
```
**Fix:** Flatten using variables or consolidate filter predicates.

### Missing variable reuse
```dax
// Anti-pattern: same expression evaluated twice
IF(SUM(Sales[Amount]) > 0, SUM(Sales[Amount]) * 1.1, 0)

// Fix: compute once with VAR
VAR _total = SUM(Sales[Amount])
RETURN IF(_total > 0, _total * 1.1, 0)
```
**Why:** Variables are evaluated once. Duplicate expressions are evaluated multiple times.

### ALL on fact tables
```dax
// Anti-pattern: removes all filters from a large table
CALCULATE([Measure], ALL(Sales))

// Fix: be specific about which filters to remove
CALCULATE([Measure], REMOVEFILTERS(Sales[Category]))
```
**Why:** ALL on a fact table removes ALL filters, which is rarely the intent and is memory-intensive.

### Iterator when aggregator works
```dax
// Anti-pattern: unnecessary row-by-row iteration
SUMX(Sales, Sales[Amount])

// Fix: simple aggregation
SUM(Sales[Amount])
```
**Why:** Iterators (SUMX, AVERAGEX, etc.) process row by row. Aggregators are optimized.

## Info Patterns

### No format string
Measures displaying as generic numbers when they should show currency, percentage, etc.
**Fix:** Add `formatString: $#,##0` or `formatString: 0.0%` as appropriate.

### No description annotation
Measures without explanatory text.
**Fix:** Add `annotation Description = "Explanation of what this measure calculates"`

### Long expressions without variables
Measures over 5 lines that don't use VAR for readability.
**Fix:** Extract sub-expressions into named variables.

## Time Intelligence Patterns

### Time intelligence without proper date table
Using DATEADD, SAMEPERIODLASTYEAR, etc. without a dedicated date dimension table. Relying on auto-generated LocalDateTables is fragile and slow.
**Fix:** Create a proper date dimension table and mark it as a date table.

### TOTALYTD vs CALCULATE + DATESYTD
```dax
// Both work, but TOTALYTD is cleaner for simple cases
TOTALYTD([Measure], 'Date'[Date])

// CALCULATE + DATESYTD is more flexible for complex scenarios
CALCULATE([Measure], DATESYTD('Date'[Date]))
```
**Note:** Neither is wrong — flag only when used inconsistently within the same model.
