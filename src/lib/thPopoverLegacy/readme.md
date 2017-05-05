# Popover (Legacy)

<span class="badge red">Deprecated</span>

Add small overlays of content, like those on the iPad, to any element for
housing secondary information.

`th-popover-legacy` accepts the name of a `th-popover-content` element where its
content will come from.

`th-popover-url` accepts a URL from which it will fetch its content.

`th-popover-content` specifies a block of content used for display in a
popover. The element must specify a unique `name` used to identify the
content in `th-popover-legacy` and `PopoverManager` api.

`th-popover-target` specifies an element which can accept a popover
programatically via the `PopoverManager` api. The attribute must specify a
unique name used to identify the content.

`th-popover-legacy` and `th-popover-url` also accept an optional `overflow` param that
will apply a styling class. This is intended to be used when dealing with
legacy components that have elements that are positioned absolutely (such as
datepickers). The overflow property is set to `auto` by default. Valid options:

  - `visible`
  - `hidden`

Adding the attribute `th-popover-persist` to an `a` element within the popover will
prevent it from dismissing when clicked.

## Usage

### Fetch remote content

```html
<a href="" th-popover-url="/templatePath.html">Trigger</a>
```

### Fetch inline content

```html
<a href="" th-popover-legacy="content">Trigger</a>

<th-popover-content name="content">
  <h1>Some content</h1>
</th-popover-content>
```

### Trigger from script

```html
<a href="" th-popover-target="target">Target</a>

<th-popover-content name="content">
  <h1>Some content</h1>
</th-popover-content>
```

```coffeescript
controller: (PopoverManager, $http) ->
  # Remote content
  PopoverManager.showPopover(
    targetName: "target"
    contentCallback: -> $http.get "http://www.google.com"
  )

  # Inline content
  contentPromise =
  PopoverManager.showPopover(
    targetName: "target"
    contentCallback: -> PopoverManager.getContent "content"
  )
```
