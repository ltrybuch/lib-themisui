# Popover — `thPopover\thPopoverUrl`

## Description

Add small overlays of content, like those on the iPad, to any element for housing secondary information.

`th-popover` accepts the name of a `th-popover-content` element where it will fetch its inner content from.

`th-popover-url` accepts a URL of where it will fetch its inner content from.

`th-popover-content` specifies a block of content used for display in a popover.

`th-popover-target` specifies an element which can accept a popover programatically via the `PopoverManager` api.

`th-popover` and `th-popover-url` also accept an optional `overflow` param that will apply a styling class. This is intended to be used when dealing with legacy components that have elements that are positioned absolutely (such as datepickers). The overflow property is set to `auto` by default. Valid options:

  - `visible`
  - `hidden`

## Usage


### Markup
`<a href="" th-popover-url="/templatePath.html">Trigger</a>`
