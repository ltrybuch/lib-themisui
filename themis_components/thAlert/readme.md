# Alert Message - `thAlert`

Alert messages are used to inform a user that an action has taken place or to
raise awareness to an issue.

## Design Patterns

Examples of acceptable usage:
- Indicate that a message has been sent sucessfully
- Indicate that a message failed to send
- Inform a user they are trying to message a contact with no email address

Do not use an alert message as an indicator that something is loading
or for an announcement.

## Usage

`<th-alert-anchor></th-alert-anchor>` is required in the body of your application.
It's positioned absolutely to appear at the top of the page, so ensure it's not
placed in a relatively positioned container.

There are 3 types of alerts that are called with their own functions
using the `AlertManager` service:
- Success alerts with `showSuccess()`
- Error alerts with `showError()`
- Warning alerts with `showWarning()`

Each function accepts a `message` parameter. The `message` parameter is the
actual text of the message that you'd like to show. Such as:
`'Your message has been sent successfully.'`

An example of a success alert:

```coffeescript
AlertManager.showSuccess "Your message has been sent successfully."
```

An example of an error alert:

```coffeescript
AlertManager.showError "Your message has failed to send."
```

An example of a warning alert:

```coffeescript
AlertManager.showWarning "The selected contact does not have an email address."
```
