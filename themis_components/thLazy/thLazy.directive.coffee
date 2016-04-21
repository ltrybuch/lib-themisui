uuid = require 'uuid'
qs = require 'qs'

angular.module('ThemisComponents')
  .directive "thLazy", ->
    restrict: "EA"
    template: require './thLazy.template.html'
    controllerAs: "lazy"
    bindToController: true
    scope:
      src: "@"
      name: "@"
      errorMessage: "@"
    controller: ($scope, LazyManager) ->
      @loading = yes
      @loadError = no
      @messageOverride = @errorMessage?
      LazyManager.addLazyObject(this)

      @loadingComplete = ->
        @loading = no

      @reload = ->
        if @src.indexOf('?') != -1
          queryString = @src.substring( @src.indexOf('?') + 1 )
          params = qs.parse(queryString)
          params.refreshCacheBuster = uuid.v1()
          @src = @src.replace(queryString, qs.stringify(params))
        else
          @src = @src + "?refreshCacheBuster=" + uuid.v1()

      $scope.$on "$includeContentError", (event, args) =>
        @loadError = yes
        @loading = no

      return
