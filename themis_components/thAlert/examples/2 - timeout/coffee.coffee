angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (AlertManager) ->

    @defaultTimeout = ->
      AlertManager.showSuccess "This will disappear in 3 seconds."

    @longerTimeout = ->
      AlertManager.showSuccess "This will disappear in 10 seconds.", {timeout: 10000}

    @noTimeout = ->
      AlertManager.showSuccess "This won't disappear unless dismissed.", {timeout: 0}

    return
