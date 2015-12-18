angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader, TableSort) ->
    data = fixtures()
    {sort} = TableSort

    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader
          name: 'Id'
          sortField: 'id'

        TableHeader
          name: 'Name'
          sortField: 'name'
          sortActive: true

        TableHeader
          name: 'Twitter'
          sortField: 'twitter'
      ]

      fetchData: ({sortHeader}, updateData) ->
        sortedData = sort data, sortHeader
        updateData {data: sortedData, totalItems: sortedData.length}

    return


fixtures = ->
  celebrities = [
    {id: 1, name: "Jose Valim",  twitter: "josevalim"}
    {id: 2, name: "Dan Abramov", twitter: "dan_abramov"}
    {id: 3, name: "Todd Motto",  twitter: "toddmotto"}
    {id: 4, name: "Yehuda Katz", twitter: "wycats"}
    {id: 10, name: "Paul Graham", twitter: "paulg"}
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
