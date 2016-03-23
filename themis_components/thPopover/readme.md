# Popover — `thPopover\thPopoverUrl`

## Description

Add small overlays of content, like those on the iPad, to any element for
housing secondary information.

`th-popover` accepts the name of a `th-popover-content` element where its
content will come from.

`th-popover-url` accepts a URL from which it will fetch its content.

`th-popover-content` specifies a block of content used for display in a
popover. The element must specify a unique `name` used to identify the
content in `th-popover` and `PopoverManager` api.

`th-popover-target` specifies an element which can accept a popover
programatically via the `PopoverManager` api. The attribute must specify a
unique name used to identify the content.

`th-popover` and `th-popover-url` also accept an optional `overflow` param that
will apply a styling class. This is intended to be used when dealing with
legacy components that have elements that are positioned absolutely (such as
datepickers). The overflow property is set to `auto` by default. Valid options:

  - `visible`
  - `hidden`

### Markup

Fetch remote content.

```html
<a href="" th-popover-url="/templatePath.html">Trigger</a>
```

Fetch inline content.

```html
<a href="" th-popover="content">Trigger</a>

<th-popover-content name="content">
  <h1>Some content</h1>
</th-popover-content>
```

Trigger from script.

```html
<a href="" th-popover-target="target">Target</a>

<th-popover-content name="content">
  <h1>Some content</h1>
</th-popover-content>
```

```coffeescript
controller: (PopoverManager, $http) ->
  # Remote content
  contentPromise = $http.get "http://www.google.com"
  PopoverManager.showPopover("target", contentPromise)

  # Inline content
  contentPromise = PopoverManager.getContent("content")
  PopoverManager.showPopover("target", contentPromise)
```
