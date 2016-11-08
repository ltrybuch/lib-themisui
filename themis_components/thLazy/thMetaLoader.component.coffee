class MetaLoader
  constructor: (@$q) ->
    @loading = yes
    @lazyPromises = []

  registerWithMetaLoader: ->
    resolveFunc = null
    promise = @$q (resolve) ->
      resolveFunc = resolve

    @lazyPromises.push promise

    return resolveFunc

  $postLink: ->
    @$q.all(@lazyPromises).then => @loading = no

MetaLoader.$inject = ["$q"]

angular.module('ThemisComponents')
  .component "thMetaLoader",
    transclude: true
    controllerAs: "meta"
    template: require "./thMetaLoader.template.html"
    controller: MetaLoader
