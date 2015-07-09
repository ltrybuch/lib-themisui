# Popover — `thPopover`

## Description

Add small overlays of content, like those on the iPad, to any element for housing secondary information.

`th-popover` accepts a URL of where it will fetch its inner content from.

## Usage

To fix the height of the content, and initiate the scrolling in the popover content, define a height inline 
style on the content container. Otherwise, the popover will fit the content.


### Markup
`<a href="" th-popover="/templatePath.html">Trigger</a>`

/templatePath.html

```
<div style="height: 200px;">
  Your lengthy content extending down the y axis
</div>
```