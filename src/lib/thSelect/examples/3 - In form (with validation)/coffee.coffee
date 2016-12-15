angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", ($http) ->

    @submission = ""
    @required = true
    @genres = [
      {name: "Animation", value: 1365}
      {name: "Comedies", value: 77232}
      {name: "Documentary", value: 46576}
      {name: "Family", value: 43040}
      {name: "Horror", value: 8985}
      {name: "Musical", value: 2125}
      {name: "Romance", value: 7442}
      {name: "Comic Book and Superhero", value: 43040}
    ]

    @submit = (form) ->
      if form.$valid
        params =
          genre: @favoriteGenre
        $http.post("/echo", params).then (data) =>
          @submission = data.data
      else
        @submission = "Missing form data. Could not submitted."

    return
