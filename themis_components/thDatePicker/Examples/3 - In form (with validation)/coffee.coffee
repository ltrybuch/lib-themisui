angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoCtrl", ($http) ->
    @dueDate = moment()

    @submission = ""
    @required = true

    @submit = (form) ->
      if form.$valid
        params =
          dueDate: @dueDate
        $http.post("/echo", params).then (data) =>
          @submission = data.data
      else
        @submission = "Missing form data. Could not submitted."

    return
