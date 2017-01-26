angular.module("thLoaderDemo")
  .controller "thLoaderDemoCtrl1", ($q, $timeout, $interval) ->

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
