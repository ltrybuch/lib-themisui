# Flexbox Helpers

A subset of [Bootstrap v4](https://v4-alpha.getbootstrap.com)'s helper classes have been made available for use as a part of the base and Themis themes.

Refer to [A Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) for a good visual explanation of what each flex rule does is. For more examples usages of these helper classes, consult the [Bootstrap Flexbox documentation](https://v4-alpha.getbootstrap.com/utilities/flexbox/).

## Responsive
The helper classes below also have responsive variations that contains the name of the breakpoint in their class names, ex. `.d-xl-flex`. See the [Breakpoints](#breakpoints) section below for the minimum viewport widths for each breakpoint.

## Available classes
### Parent elements

These helper classes are for altering the behaviour of flex container elements. Note that the classes noted as (**default**) are used to restore default behavior by overriding other applied rules.

#### [Display](https://v4-alpha.getbootstrap.com/utilities/flexbox/#enable-flex-behaviors)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.d-flex` | `.d-xx-flex` | `display: flex` |
| `.d-inline-flex` | `.d-xx-inline-flex` | `display: inline-flex` |

#### [Direction](https://v4-alpha.getbootstrap.com/utilities/flexbox/#direction)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.flex-row` | `.flex-xx-row` | `flex-direction: row` (**default**) |
| `.flex-row-reverse` | `.flex-xx-row-reverse` | `flex-direction: row-reverse` |
| `.flex-column` | `.flex-xx-column` | `flex-direction: column` |
| `.flex-column-reverse` | `.flex-xx-column-reverse` | `flex-direction: column-reverse` |

#### [Justify content](https://v4-alpha.getbootstrap.com/utilities/flexbox/#justify-content)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.justify-content-start` | `.justify-content-xx-start` | `justify-content: flex-start` (**default**) |
| `.justify-content-end` | `.justify-content-xx-end` | `justify-content: flex-end` |
| `.justify-content-center` | `.justify-content-xx-center` | `justify-content: center` |
| `.justify-content-between` | `.justify-content-xx-between` | `justify-content: space-between` |
| `.justify-content-around` | `.justify-content-xx-around` | `justify-content: space-around` |

#### [Align items](https://v4-alpha.getbootstrap.com/utilities/flexbox/#align-items)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.align-items-stretch` | `.align-items-xx-stretch` | `align-items: stretch` (**default**) |
| `.align-items-start` | `.align-items-xx-start` | `align-items: flex=start` |
| `.align-items-end` | `.align-items-xx-end` | `align-items: flex-end` |
| `.align-items-center` | `.align-items-xx-center` | `align-items: center` |
| `.align-items-baseline` | `.align-items-xx-baseline` | `align-items: baseline` |

#### [Wrap](https://v4-alpha.getbootstrap.com/utilities/flexbox/#wrap)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.flex-nowrap` | `.flex-xx-nowrap` | `flex-wrap: nowrap` (**default**) |
| `.flex-wrap` | `.flex-xx-wrap` | `flex-wrap: wrap` |
| `.flex-wrap-reverse` | `.flex-xx-wrap-reverse` | `flex-wrap: wrap-reverse` |

#### [Align content](https://v4-alpha.getbootstrap.com/utilities/flexbox/#align-content)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.align-content-start` | `.align-content-xx-start` | `align-content: flex-start` (**default**) |
| `.align-content-end` | `.align-content-xx-end` | `align-content: flex-end` |
| `.align-content-center` | `.align-content-xx-center` | `align-content: center` |
| `.align-content-between` | `.align-content-xx-between` | `align-content: space-between` |
| `.align-content-around` | `.align-content-xx-around` | `align-content: space-around` |
| `.align-content-stretch` | `.align-content-xx-stretch` | `align-content: stretch` |

### Child elements
These helper classes are for altering the behaviour of individual flex items.

#### [Align self](https://v4-alpha.getbootstrap.com/utilities/flexbox/#align-self)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.align-self-auto` | `.align-self-xx-auto` | `align-self: auto` (**default**) |
| `.align-self-stretch` | `.align-self-xx-stretch` | `align-self: stretch` |
| `.align-self-start` | `.align-self-xx-start` | `align-self: flex=start` |
| `.align-self-end` | `.align-self-xx-end` | `align-self: flex-end` |
| `.align-self-center` | `.align-self-xx-center` | `align-self: center` |
| `.align-self-baseline` | `.align-self-xx-baseline` | `align-self: baseline` |

#### [Order](https://v4-alpha.getbootstrap.com/utilities/flexbox/#order)
| Class | Responsive Class | Value |
|:---| :---| :---|
| `.order-0` | `.order-xx-0` | `order: 0` (**default**) |
| `.order-first` | `.order-xx-first` | `order: -1` |
| `.order-last` | `.order-xx-last` | `order: 1` |

### Margin helpers

#### [Auto Margins](https://v4-alpha.getbootstrap.com/utilities/flexbox/#auto-margins)
These margin helper classes are for breaking a single flex item from the normal flex alignment/justification.

| Class | Responsive Class | Value |
|:---| :---| :---|
| `.ml-auto` | `.ml-xx-auto` | `margin-left: auto` |
| `.mr-auto` | `.mr-xx-auto` | `margin-right: auto` |
| `.mt-auto` | `.mt-xx-auto` | `margin-top: auto` |
| `.mb-auto` | `.mb-xx-auto` | `margin-bottom: auto` |

### Extensions

This section covers helper classes that are implemented in the base and Themis themes but did not ship with Bootstrap v4. (**experimental**)

#### [Grow/Shrink/Basis](https://developer.mozilla.org/en/docs/Web/CSS/flex)
| Class | Responsive Class | Value | Description |
|:---| :---| :---| :---|
| `.flex-grow` | `.flex-xx-grow` | `flex: 1` | Used for allowing a flex item to fill the available space. If used by multiple flex items, space will be equally distributed among them. |
