# Disclosure

This set of components implements a [disclosure widget](https://en.wikipedia.org/wiki/Disclosure_widget).

A disclosure has 2 parts:
* a button that the user can click: `th-disclosure-toggle`
* a content that is being displayed or hidden on click: `th-disclosure-content`

## Usage

Both components have a mandatory, unique attribute called `name`.

The `th-disclosure-toggle` component has an optional `expanded` attribute with
which you can control the expanded state of the disclosure. This attribute
accepts an expression and can be controlled via a controller variable. If the
optional `expanded` attribute is not defined, the disclosure defaults `expanded`
to false.

You are free to put anything inside the component tags - everything will be transcluded.

```
<th-disclosure-toggle name="unique-string-id">Text for the toggle button</th-disclosure-toggle>
```

```
<th-disclosure-content name="unique-string-id">Content to display or hide</th-disclosure-content>
```

They may be placed far apart from each other on the page. The only requirement
is that they are connected through the same unique string id, which is given
for the `name` attribute of both components.

### Attributes

* `text-side`
  * Choose which side of the caret you'd like the text to appear, `left` or `right`.
    Default is `left`.

* `ng-disabled`
  * Disable or enable the thDisclosure component.

## Accessibility

The `thDisclosure` component borrows accessibility suggestions from the *"Accordion"* component
in the [WAI-ARIA Authoring Practices 1.1](https://www.w3.org/TR/wai-aria-practices-1.1/#accordion) document.

### Keyboard Interaction
`thDisclosure` can be toggled with the `Enter` key.

### Optional Accessibility Attributes
* `aria-label` [string] Screen readers will read the disclosure toggle's name by
default. Setting the `aria-label` attribute will override the text read by the
screen reader.

* `aria-describedby` [string] A description of the disclosure's functionality or contents
can be provided by setting the `aria-describedby` attribute to that of the disclosure toggle's
`id` on the description element.
