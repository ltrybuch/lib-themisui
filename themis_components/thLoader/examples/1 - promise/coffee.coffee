angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($q, $timeout, $interval) ->

    @delay = 4000
    @seconds = @delay / 1000

    @deferred = $q.defer()
    @promise = @deferred.promise

    @startTimer = ->
      # simulate time to resolve
      $timeout =>
        @deferred.resolve()
      , @delay

    return
