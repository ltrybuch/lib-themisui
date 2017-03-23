# Defaults

`thDefaults` gives us a mechanism to set library wide defaults within ThemisUI.

## Syntax

#### Set a default.
```coffeescript
angular.module("thDemo", ["ThemisComponents"])

angular.module "thDemo"
  .run (thDefaults) ->
    thDefaults.set "dateFormat", "DD/MM/YYYY"
```

## Methods

### `set(key<String>, value<Object>)`
> Set the default `key` to `value`.

### `set(collection<Object>)`
> Set each key, value pair in `collection` as a default.

Note: This will merge passed defaults into the internal set.

### `entries()` → `collection<Object>`
> Return a `collection` of all defaults.

### `get(key<String)` → `value<Object>`
> Fetch the value for default `key`.

## Available Defaults

### `dateFormat<String>`

#### Accepts:
- "YYYY-MM-DD" **[Default]**
- "MM/DD/YYYY"
- "DD/MM/YYYY"

## Future

- Components should be able to define their own available defaults rather than having to centralize
  them here.
- Defaults should be validated to ensure that they are valid.
