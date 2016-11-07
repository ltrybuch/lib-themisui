angular.module('ThemisComponents')
  .factory 'LazyManager', ->
    lazyObjects = {}

    reload = (name) ->
      lazyObjects[name].reload()

    addLazyObject = (lazyObject) ->
      if lazyObject.name
        lazyObjects[lazyObject.name] = lazyObject

    return {
      reload
      addLazyObject
      _lazyObjects: lazyObjects
    }
