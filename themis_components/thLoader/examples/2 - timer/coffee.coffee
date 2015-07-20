angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($scope, $interval) ->
    @delay = 5000
    @counter = @delay / 1000

    @callAtInterval = ->
      if @counter > 0
        @counter--
      else
        $interval.cancel timer

    timer = $interval ( => @callAtInterval()), 1000

    return