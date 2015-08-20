angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @foo = ->
      alert "foo"

    @links = [
      { name: "Link One", url: "/exampleTemplates/thModalExampleTemplate.html", icon: "anchor" }
      { name: "Link Two", url: "/exampleTemplates/thModalExampleTemplate.html" }
      { name: "Action One", action: @foo, icon: "star" }
      { name: "", action: @foo, icon: "star-o" }
      # { type: 'divider' }
    ]

    return
