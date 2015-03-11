# `thBindMarkdown`

The `thBindMarkdown` component evaluates a Markdown string and binds it to the contents of the given element.

## Usage

### Controller
```
$scope.markdownText = """
    - one
    - two
"""
```

### Markup
```
<span th-bind-markdown="markdownText"></span>
```

### Result
```
<ul>
    <li>one</li>
    <li>two</li>
</ul>
```
