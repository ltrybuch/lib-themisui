# Grid

<span class="badge blue">Testing</span>
<span class="badge light-grey">Web</span>

Use `th-row` and `th-column` to setup up grid based layouts using flexbox. It is built using [Bootstrap's Grid System](https://v4-alpha.getbootstrap.com/layout/grid/) so additional info may be found there.

## Usage
```html
<!-- Fixed Width Columns -->
<th-row>
  <th-column columns="6">
    <!-- Your content here... -->
  </th-column>
  <th-column columns="3">
    <!-- ... here ... -->
  </th-column>
  <th-column columns="3">
    <!-- ...and here! -->
  </th-column>
</th-row>

<!-- Automatic Width Columns -->
<th-row>
  <th-column>
    <!-- Your content here... -->
  </th-column>
  <th-column>
    <!-- ...and here! -->
  </th-column>
</th-row>
```

## API Reference
### th-row
| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| hide-gutters  | boolean | Description | *optional* |
| align  | string  | By default, columns are aligned in the centre of their parent<br />Acceptable values: `left`, `right`, `vcentre`  | *optional* |

### th-column
| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| columns | number | How wide this this column is, represented by how many "columns" of space it takes up. If not provided, the column will automatically size itself.<br />Acceptable value is a number between `1` and `12` | *optional* |
| columns-lg | number | Same as `columns`, but for large screens | *optional* |
| columns-sm | number | Same as `columns`, but for small screens | *optional* |
| columns-xs | number | Same as `columns`, but for extra small screens | *optional* |
| hide-lg | boolean | Hide this column on large screens | *optional* |
| hide-md | boolean | Hide this column on medium screens | *optional* |
| hide-sm | boolean | Hide this column on small screens | *optional* |
| hide-xs | boolean | Hide this column on extra small screens | *optional* |


## Breakpoints
| Identifier         | Lower bounds        | Upper bounds   |
|:-------------    |:-------     | :-------------|
| `xs` | 0 | 575px |
| `sm` | 576px | 767px |
| `md` | 768px | 991px |
| `lg` | 992px | 1199px |
| `xl` | 1200px | ∞ |
