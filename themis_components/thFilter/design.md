#thFilter

The thFilter component is currently applied through the following directives:

```html
<th-static-filters options="options"></th-static-filters>
<th-custom-filters options="options"></th-custom-filters>
<th-search-row options="options"></th-search-row>
```

`th-static-filters` specifies a block of anchored filter components that are
always visible to the user.

`th-custom-filters` specifies the custom filter pattern, where a user can
add a filter, select a type from a dropdown and enter a corresponding value.

`th-search-row` specifies the search pattern, consisting of an input field
with adjacent search button.

All directives rely on the following data types.

##Data Types

###Filters: FilterBase, SelectFilter, InputFilter

All filter types inherit from the `FilterBase` class. `FilterBase` includes
methods for getting the filter id, label, and value. SelectFilter and
InputFilter are the only supported filters in the initial implementation.  

###FilterSet

`FilterSet` provides an interface for building queries. `FilterSet` accepts as
an option the function `onFilterChange`. This function is called whenever a
value in the `FilterSet` changes. When called, the user can then retrieve the
query string from the `FilterSet` or iterate over the filters.

##Directives

The `th-static-filters`, `th-custom-filters` and `th-search-row` directives also
depend on the following filter field directive:

###Filters

```html
<th-filter-select></th-filter-select>

<th-filter-input></th-filter-input>
```
These directives are wrappers for the underlying components, in this case
`th-select` and `th-input`. They are used by the previously mentioned
directives.

###Static filters

```html
<th-static-filters></th-static-filters>
```

`th-static-filters` accepts as arguments an `options` hash. The options hash
expects a `FilterSet` and an array of filters (see above). In the template, we
loop over this array (see `ng-repeat`) and using `ng-switch` add the
corresponding directive to the template based on the filter type. For example,
if `type` equals `select`, the above-mentioned `th-filter-select` directive gets
compiled into the DOM.

###Custom filters

```html
<th-custom-filters></th-custom-filters>
```

`th-custom-filters` accepts as arguments an `options` hash. The options hash
expects a `FilterSet` and an array of filter types. The `th-custom-filters`
directive provides a mechanism for adding and removing `th-custom-filter-row`s.
Each row has a unique identifer, begins at 0 and is incremented by 1 for each
successive row. This identifer is stored in the array `@customFilterRows`. In
the template, using `ng-repeat` for each identifer in our array, we add a
`th-custom-row-filter` to the DOM. Note that the identifer is passed to the
`th-custom-row-filter` as an attribute. When a `th-custom-row-filter` is removed
from the component (by clicking 'remove'), this identifer is passed back to the
`th-custom-filters` function `removeCustomRow(identifer)` to remove that
particular row from the array, and `ng-repeat` acts to remove that row's element
from the DOM.

###Custom filter row

```html
<th-custom-filter-row></th-custom-filter-row>
```

`th-custom-filter-row`s are the child nodes of `th-custom-filters`. Each row
consists of a select component for selecting the filter type, the actual
filter itself (eg. instance of `th-filter-select`) and a remove button. The
select field presents to the user the filter types passed into
`th-custom-filters`. When the selection changes, `rowSelectValue` changes and
`onRowSelectChange` is triggered by the select. Next, the existing filter is
removed if one is present and `onFilterChange` is called when necessary. At
this point, a new `FilterBase` instance is created (ie. SelectFilter) and added
to the `FilterSet`. The DOM is updated in the template based on
`rowSelectValue.type`, and the corresponding filter directive
(ie. th-filter-select) is instantiated with the `FilterBase` object.

###Search row

```html
<th-search-row></th-search-row>
```

`th-search-row` accepts as arguments an `options` hash and an optional field
identifier. The options hash expects a `FilterSet` which is what the
corresponding `FilterBase` object gets added to. `field-identifier` is the name
of the parameter used for querying (defaults to `query`).
