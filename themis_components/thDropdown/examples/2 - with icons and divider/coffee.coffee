angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @foo = ->
      alert "foo"

    @links = [
      { name: "Link One", url: "#", icon: "anchor" }
      { name: "Link Two", url: "#", icon: "car"}
      { divider: 'true' }
      { name: "Action One", action: @foo, icon: "star" }
      { name: "Action Two", action: @foo, icon: "star-o" }
    ]

    return
