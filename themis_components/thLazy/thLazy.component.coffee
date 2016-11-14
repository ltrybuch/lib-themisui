uuid = require 'uuid'
qs = require 'qs'

class LazyController
  constructor: (@$scope, @LazyManager) ->
    "ngInject"

    @resolveFunc = null
    @loading = yes
    @loadError = no
    @messageOverride = @errorMessage?

  $onInit: ->
    @resolveFunc = @metaLoader?.registerWithMetaLoader()
    @LazyManager.addLazyObject this

    @$scope.$on "$includeContentError", =>
      @loadError = yes
      @loading = no
      @resolveFunc() if @resolveFunc

  loadingComplete: ->
    @loadError = no
    @loading = no
    @resolveFunc() if @resolveFunc

  reload: ->
    @loadError = no
    @loading = yes

    if @src.indexOf('?') != -1
      queryString = @src.substring( @src.indexOf('?') + 1 )
      params = qs.parse(queryString)
      params.refreshCacheBuster = uuid.v1()
      @src = @src.replace(queryString, qs.stringify(params))
    else
      @src = @src + "?refreshCacheBuster=" + uuid.v1()


angular.module('ThemisComponents')
  .component "thLazy",
    template: require './thLazy.template.html'
    controllerAs: "lazy"
    require:
      metaLoader: "?^thMetaLoader"
    bindings:
      src: "@"
      name: "@"
      errorMessage: "@"
    controller: LazyController
