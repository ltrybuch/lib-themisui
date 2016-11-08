# `thModalTitlebar`

A modal's titlebar is used to visibly name the modal and commonly provide it with a close button.

## Usage

`thModalTitlebar` should be the first element within your modal.

```html
<th-modal-titlebar
  title="Foo"
  show-close-button="true|false"
  type="standard|destroy"
  >
</th-modal-titlebar>
```

## Accessibility
TODO: Checkin with Craig on this.

## Attributes

### `title` &lt;string&gt;
> The title text to show in the titlebar.
>
> A long title will be truncated with ….

### `show-close-button` &lt;boolean&gt; [optional]
> Control if the close button is visible or not.

Defaults to true.

### `type` &lt;string&gt; [optional]
> Set the type of titlebar. This is used for different styles of titlebar if, for example you are
> displaying a message of a particular type to the user.

Accepts:
  - `standard`
  - `destroy`

Defaults to `standard`
