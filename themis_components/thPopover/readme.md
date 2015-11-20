# Popover — `thPopover`

## Description

Add small overlays of content, like those on the iPad, to any element for housing secondary information.

`th-popover` accepts a URL of where it will fetch its inner content from.

`th-popover` also accepts an optional `overflow` param that will apply a styling class. This is intended to be used when dealing with legacy components that have elements that are positioned absolutely (such as datepickers). The overflow property is set to `auto` by default. Valid options:

  - `visible`
  - `hidden`

## Usage


### Markup
`<a href="" th-popover="/templatePath.html">Trigger</a>`
