angular.module("ThemisComponents")
  .directive "thItem", ->
    restrict: "E"
    replace: true
    require: "^thDropdown"
    scope:
      href: "@"
      name: "@"
      icon: "@"
    template: (element, attrs) ->
      switch
        when attrs.href?
          require './thItem.link.template.html'
        else
          require './thItem.action.template.html'





