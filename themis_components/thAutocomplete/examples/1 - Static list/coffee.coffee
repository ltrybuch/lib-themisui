angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($scope, $http, $timeout) ->
    @colours = fixtures()
    @colour = null

    # $timeout =>
    #   console.log 'setting'
    #   @colours = fixtures2()
    # , 5000

    @onChange = ->
      console.log 'New value: ' + @colour

    @fetchData = (term) =>
      console.log term

      $http
        method: 'GET'
        url: 'https://api.github.com/search/repositories'
        params:
          q: term
      .then (response) =>

        @colours = response.data.items.map (item) ->
          angular.extend(item, {
            # Required parameters
            text: item.name
            id: item.id
            })

        # @colours = fixtures2()
        # $scope.demo.colours = fixtures2()
        # debugger
    return

fixtures = ->
  return [
    {id: 0, text: "zero"}
    {id: 1, text: "one"}
    {id: 2, text: "two"}
    {id: 3, text: "three"}
    {id: 4, text: "four"}
  ]


fixtures2 = ->
  return [
    {id: 5, text: "ack"}
    {id: 6, text: "bill"}
    {id: 7, text: "cry"}
    {id: 8, text: "destitute"}
    {id: 9, text: "enough"}
  ]
