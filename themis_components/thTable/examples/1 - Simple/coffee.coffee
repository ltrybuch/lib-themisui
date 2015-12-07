angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader) ->
    celebrities = [
      {name: "Jose Valim",  twitter: "josevalim"}
      {name: "Dan Abramov", twitter: "dan_abramov"}
      {name: "Todd Motto",  twitter: "toddmotto"}
      {name: "Yehuda Katz", twitter: "wycats"}
    ]

    twitterUser = (spec) ->
      {name, twitter} = spec

      twitterProfile = "http://twitter.com/" + twitter
      twitterFollowers = twitterProfile + "/followers"
      twitterFollowing = twitterProfile + "/following"
      twitterLikes = twitterProfile + "/likes"

      return {
        name
        twitter
        twitterProfile
        twitterFollowing
        twitterFollowers
        twitterLikes
      }

    @tableDelegate = new SimpleTableDelegate
      data: celebrities.map twitterUser

      headers: [
        new TableHeader
          name: 'Name'

        new TableHeader
          name: 'Twitter'
      ]

    return
