# Disclosure — `thDisclosureToggle` / `thDisclosureContent`

## Description

This set of components implements a [Disclosure widget](https://en.wikipedia.org/wiki/Disclosure_widget).

A disclosure has 2 parts:
* a button that the user can click: `th-disclosure-toggle`
* a content that is being displayed or hidden on click: `th-disclosure-content`

## Usage

Both components must be used as attributes on html elements.

```
<any-html-element th-disclosure-toggle="unique-string-id">Text for the toggle button</any-html-element>
```

```
<another-html-element th-disclosure-content="unique-string-id">Content to display or hide</another-html-element>
```

They may be placed on elements far apart from each other on the page. The only requirement is that they are connected through the same unique string id, which is given as the value for both attributes.
