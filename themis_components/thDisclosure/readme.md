# Disclosure — `thDisclosureToggle` / `thDisclosureContent`

## Description

This set of components implements a [Disclosure widget](https://en.wikipedia.org/wiki/Disclosure_widget).

A disclosure has 2 parts:
* a button that the user can click: `th-disclosure-toggle`
* a content that is being displayed or hidden on click: `th-disclosure-content`

## Usage

Both components have a mandatory, unique attribute called `name`.

You are free to put anything inside the component tags - everything will be transcluded.

```
<th-disclosure-toggle name="unique-string-id">Text for the toggle button</th-disclosure-toggle>
```

```
<th-disclosure-content name="unique-string-id">Content to display or hide</th-disclosure-content>
```

They may be placed far apart from each other on the page. The only requirement is that they are connected through the same unique string id, which is given for the `name` attribute of both components.
