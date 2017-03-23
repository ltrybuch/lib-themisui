# Contextual Message

The `thContextualMessage` component is used to provide anchor points for contextually relevant messages. These are seen in feature announcements to direct users where to go to activate a feature after the initial announcement modal.

## Usage

This component is primarily interacted with through the `ContextualMessageManager` service.

### Controller
```
  ContextualMessageManager.showAlert "sample", "This is Important."
```

### Markup
```
  <a href="" th-contextual-message-anchor="sample">Somethink Important</a>
```
