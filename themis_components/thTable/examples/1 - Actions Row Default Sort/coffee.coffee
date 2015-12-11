fixtures = ->
  celebrities = [
    {id: 1, name: "Jose Valim",  twitter: "josevalim"}
    {id: 2, name: "Dan Abramov", twitter: "dan_abramov"}
    {id: 3, name: "Todd Motto",  twitter: "toddmotto"}
    {id: 4, name: "Yehuda Katz", twitter: "wycats"}
    {id: 5, name: "Paul Graham", twitter: "paulg"}
  ]

  twitterUser = (spec) ->
    {id, name, twitter} = spec

    twitterProfile = "http://twitter.com/" + twitter
    twitterFollowers = twitterProfile + "/followers"
    twitterFollowing = twitterProfile + "/following"
    twitterLikes = twitterProfile + "/likes"

    return {
      id
      name
      twitter
      twitterProfile
      twitterFollowing
      twitterFollowers
      twitterLikes
    }

  celebrities.map twitterUser


angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader) ->
    data = fixtures().sort (a, b) -> a.name.localeCompare b.name

    @tableDelegate = new SimpleTableDelegate
      data: data

      headers: [
        new TableHeader
          name: 'Id'
          sortField: 'id'

        new TableHeader
          name: 'Name'
          sortField: 'name'
          sortEnabled: 'ascending'

        new TableHeader
          name: 'Twitter'
          sortField: 'twitter'
      ]

    return
