angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", ($http) ->
    @submission = ""
    @genres = [
      {name: "Pick one..", value: ""}
      {name: "Animation", value: 1365}
      {name: "Comedies", value: 77232}
      {name: "Documentary", value: 46576}
      {name: "Family", value: 43040}
      {name: "Horror", value: 8985}
      {name: "Musical", value: 2125}
      {name: "Romance", value: 7442}
      {name: "Comic Book and Superhero", value: 43040}
    ]
    @required = true
    @submit = (form) ->
      if form.$valid
        params =
          genre: @favoriteGenre
          movie: @favoriteMovie
        $http.post("/echo", params).then (data) =>
          @submission = data.data
    return
