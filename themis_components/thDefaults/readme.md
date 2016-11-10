# `thDefaults`

<!-- TOC depthFrom:2 depthTo:3 withLinks:0 updateOnSave:1 orderedList:0 -->

- Description
- Syntax
- Methods
	- `set(key<String>, value<Object>)`
	- `set(collection<Object>)`
	- `entries()` → `collection<Object>`
	- `get(key<String)` → `value<Object>`
- Available Defaults
	- `dateFormat<String>`
- Future

<!-- /TOC -->

## Description

`thDefaults` gives us a mechanism to set library wide defaults within ThemisUI.

## Syntax

#### Set a default.
```coffeescript
thDefaults.set "dateFormat", "YYYY-MM-DD"
```

#### Read a default
```coffeescript
thDefaults.get "dateFormat"
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
