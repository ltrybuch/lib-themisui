# Lazy Loading

If you want to lazy load some content `th-lazy` is the directive for you. It is a pretty simple wrapper around `ng-include` with the addition of a visual indicator that something is loading.

`th-lazy` accepts a:
- `src` URL of where it will fetch its inner content from.
- `name` The name that will be used to reference the content with `LazyManager`.
- `error-message` a message to be displayed if there is an error loading the template. _if_ nothing is passed in then defaults to "We had trouble loading your content. Try reloading the page."


## Usage

```
<th-lazy src="/url/to/view" error-message="These aren't the pages you're looking for..."></th-lazy>
```

Lazy loaded content can also be reloaded using `LazyManager`:

```coffeescript
LazyManager.reload "foo"
```
