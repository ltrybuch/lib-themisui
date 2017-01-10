# `docs-component-example`

The `ComponentExample` component is an internal component library component. It is used to embed an example of a component and allow the example to be opened in **CodePen** for testing.

## Usage

### Controller
```
$scope.name = "Example"
$scope.example =
    name: "An Example"
    coffee: [Some CoffeeScript]
    html: [Some HTML]
```

### Markup
```
<docs-component-example
    component-name="name"
    component-example="example"
    ></docs-component-example>
```
