angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($q, $timeout, $interval) ->

    @delay = 7000
    @counter = @delay / 1000

    @deferred = $q.defer()
    @promise = @deferred.promise

    # simulate time to resolve
    $timeout =>
      @deferred.resolve()
    , @delay

    @callAtInterval = ->
      if @counter > 0
        @counter--
      else
        $interval.cancel timer

    timer = $interval ( => @callAtInterval()), 1000

    return
