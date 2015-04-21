# `thComponentExample`

The `thComponentExample` component is an internal component library component. It is used to embed an example of a component and allow the example to be opened in **CodePen** for testing.

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
<th-component-example
    component-name="name"
    component-example="example"
    ></th-component-example>
```