angular.module("ThemisComponentsApp")
  .config ($stateProvider, $locationProvider, $urlRouterProvider) ->
    $locationProvider.html5Mode true

    $stateProvider
      .state
        name: "index"
        url: "/"
        component: "docsComponentDetails"

      .state
        name: "component"
        url: "/component/:name"
        component: "docsComponentDetails",
        resolve:
          # name: ($transition$) -> $transition$.params().name
          component: (catalogService, $transition$) ->
            catalogService.getComponent $transition$.params().name

      .state
        name: "docs"
        url: "/doc/:name"
        templateProvider: (catalogService, $transition$) ->
          doc = catalogService.getDoc $transition$.params().name
          if not doc or doc?.private
            return "<docs-component-details></docs-component-details>"
          else
            name = catalogService.parseComponentName doc.name
            return "<#{name}></#{name}>"

    $urlRouterProvider.otherwise "/"
