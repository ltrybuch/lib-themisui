# Flash Message - `thFlash`

Flash messages are used to inform a user that an action has either completed successfully or failed.

## Design Patterns

Use flash messages when you need to inform a user that an action has either completed successfully or failed. For example, when a message has been sent sucessfully.

Do not use a flash message as an indicator that an action is in progress, something is loading, or for an announcement.

## Usage

The `th-flash` element should be placed in your application layout file. It's positioned absolutely to appear at the top of the page, so ensure it's not placed in an element relatively positioned container.

There are two parameters that must be passed when initializing a flash message: `type` and `message`.

The `type` parameter styles the flash message. There are two options:
- `'success'` styles the message green with a checkbox icon to indicate that an action has been completed successfully.
- `'error'` styles the message red with a warning icon to indicate that an action has failed to complete.

The `message` parameter is the actual text of the message that you'd like to show. Such as: `'Your message has been sent successfully.'`

An example of a success message:

`FlashManager.showFlash 'Your message has been sent successfully.', 'success'`

An example of an error message:

`FlashManager.showFlash 'Your message has failed to send.', 'error'`

### Markup

```
<th-flash></th-flash>
```
