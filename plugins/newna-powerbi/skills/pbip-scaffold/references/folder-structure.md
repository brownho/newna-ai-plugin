# PBIP Folder Structure Reference

A Power BI Project (PBIP) is a text-based format that replaces the binary `.pbix`. Every component is a separate file, making it git-friendly.

## Top Level

```
<ProjectName>.pbip                  # Project manifest (JSON) — points to model + report
<ProjectName>.SemanticModel/        # Data model (tables, measures, relationships)
<ProjectName>.Report/               # Report (pages, visuals, bookmarks)
```

## Semantic Model

```
<ProjectName>.SemanticModel/
├── definition/
│   ├── model.tmdl                  # Top-level model metadata
│   ├── database.tmdl              # Database config (usually tiny)
│   ├── relationships.tmdl         # All model relationships
│   ├── cultures/
│   │   └── en-US.tmdl             # Localization
│   ├── expressions/               # M/Power Query expressions (shared queries)
│   └── tables/
│       ├── Sales.tmdl             # One file per table — columns, measures, partitions
│       ├── Customer.tmdl
│       ├── Date.tmdl
│       ├── Kite Measures.tmdl     # Measure-only tables (DAX measures grouped here)
│       └── LocalDateTable_*.tmdl  # Auto-generated date tables (50+ of these — noise)
├── .pbi/                          # LOCAL ONLY — never commit
│   ├── cache.abf                  # Full data cache (can be 100MB+, contains company data)
│   ├── localSettings.json         # User-specific editor prefs
│   └── editorSettings.json        # Editor state
└── .platform                      # Deployment metadata (workspace GUIDs)
```

## Report

```
<ProjectName>.Report/
├── definition.pbir                # Report metadata (JSON)
├── definition/
│   ├── pages/                     # One folder per report page
│   │   └── <PageName>/
│   │       ├── page.json          # Page metadata
│   │       └── visuals/           # One folder per visual on the page
│   │           └── <VisualID>/
│   │               └── visual.json
│   ├── bookmarks/                 # Report bookmarks
│   └── filters.json               # Report-level filters
├── StaticResources/               # Images, custom visuals
├── .pbi/                          # LOCAL ONLY — never commit
│   └── localSettings.json
└── .platform                      # Deployment metadata
```

## What to commit vs ignore

| File/Dir | Commit? | Why |
|----------|---------|-----|
| `*.pbip` | Yes | Project manifest |
| `definition/**/*.tmdl` | Yes | Core model — this IS your project |
| `definition.pbir` | Yes | Report metadata |
| `pages/**/visual.json` | Yes | Visual definitions |
| `relationships.tmdl` | Yes | Model relationships |
| `.pbi/` | **NO** | Cache with company data + user prefs |
| `.platform` | Depends | Contains deployment GUIDs — skip unless doing CI/CD |
| `LocalDateTable_*.tmdl` | Yes (annoying) | Auto-generated but part of the model |

## TMDL Format Quick Reference

Tables and measures are defined in `.tmdl` files using a human-readable syntax:

```tmdl
table 'Sales'
    lineageTag: abc-123

    column 'Revenue'
        dataType: decimal
        sourceColumn: Revenue
        lineageTag: def-456

    measure 'Total Revenue' = SUM(Sales[Revenue])
        formatString: $#,##0
        displayFolder: Financial
        lineageTag: ghi-789
```

Key things to know:
- One file per table in `definition/tables/`
- Measures live inside the table they're assigned to
- DAX expressions use `[MeasureName]` bracket references
- Multi-line DAX is wrapped in triple backticks
- `lineageTag` is a GUID used for identity tracking across serializations
- `displayFolder` organizes measures in the Power BI UI
