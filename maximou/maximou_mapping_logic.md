# Maximou mapping logic

2019-03-10

## Plectograms

### Two separate plectograms, identified by `@id`

`@id` | Value
---- | ----
`ae` | Abduction / Maximou / Emperor
`gc` |Callisthenes (Alexander) / Maximou / Greek

### Plectogram rows

Five rows (note the underscores):

* `plectogram_abduction`
* `plectogram_emperor`
* `plectogram_maximou`
* `plectogram_alexander`
* `plectogram_maximouG` 

### `<text>` elements

* Clickable
* `@id` values like `pm1` for item #1 in Maximou (`m`) line of plectogram:

Identifier | Value
----|----
 `a` | Abduction
 `m` | Maximou
 `e` | Emperor
 `c` | Callisthenes
 `g` | Greek

### `<line>` elements

* Not clickable
* Wrapper `<g>` around each set of row-to-row lines with `@id` values (note the hyphens):

	* `lines_maximou-abduction`
	* `lines_maximou-emperor`
	* `lines_maximou-alexander`
	* `lines_maximou-maximouG`

### Mapping table

`<mapping>` elements for pairwise associations, with letter (corresponding to row in plectogram: `a`, `m`, `e`, `c`, `g`) and number in the row. All are oriented around `m` (`<max>`). E.g.,

```xml
<mapping>
    <max>m28</max>
    <emp>e23</emp>
</mapping>
```

Higher-level organization (all pairs for each group of witnesses share a wrapper) is for authoring, and not needed for processing.

## Strategy

Write `@class` value onto every `<text>` and `<line>` that corresponds to value in mapping table (e.g., `e23`). These can be retrieved with:

```xml
<xsl:for-each-group select="//mapping" group-by="distinct-values(*)">
	<!-- create map from grouping key to sequence of values -->
</xsl:for-each-group>
```

When generating plectogram, consult map and add `@class` value according to group contents. Plectogram @id values will be `pm1`, rather than `m1`, because reading text will use `m1`.