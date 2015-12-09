# Lazy Loading — `thLazy`

## Description

If you want to lazy load some content `th-lazy` is the directive for you. It is a pretty simple wrapper around `ng-include` with the addition of a visual indicator that something is loading.

`th-lazy` accepts a:
- `src` URL of where it will fetch its inner content from.
- `error-message` a message to be displayed if there is an error loading the template. _if_ nothing is passed in then defaults to "There was a problem loading your page"


## Usage

```
<th-lazy src="/url/to/view" error-message="These aren't the pages you're looking for..."></th-lazy>
```
