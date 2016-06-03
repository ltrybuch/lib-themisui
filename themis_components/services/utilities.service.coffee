angular.module 'ThemisComponents'
  .factory 'Utilities', ($timeout) ->

    onChange = (callback) -> $timeout -> callback()

    return Object.freeze {
      onChange
    }
