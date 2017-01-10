# `bindMarkdown`

The `bindMarkdown` component evaluates a Markdown string and binds it to the contents of the given element.

## Usage

### Controller
```coffeescript
$scope.markdownText = """
    - one
    - two
"""
```

### Markup
```html
<span docs-bind-markdown="markdownText"></span>
```

### Result
```html
<ul>
    <li>one</li>
    <li>two</li>
</ul>
```
