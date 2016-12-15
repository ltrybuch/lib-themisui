angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ($http) ->
    @subscription = {}
    @options = [
      {name: "Angular", value: "angular"}
      {name: "React", value: "react"}
      {name: "Ember", value: "ember"}
      {name: "jQuery", value: "jquery"}
      {name: "All", value: "all"}
    ]
    @completed = {}
    @submit = (submission) ->
      temp = angular.copy submission
      $http.post '/echo', temp
        .then (data) =>
          @completed.status = data.status
          @completed.data = data.data
          @completed.statusText = data.statusText
        , (error) ->
          console.log error
    return
