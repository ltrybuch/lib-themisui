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

    data = celebrities.map twitterUser

    @tableDelegate = new SimpleTableDelegate
      data: data.sort (a, b) -> a.name.localeCompare b.name

      onSort: (header) ->
        SimpleTableDelegate.prototype.onSort.call @, header

        applySortOrder = (compareResult) ->
          if header.sortEnabled is "ascending"
            compareResult
          else
            -compareResult

        @data = data.sort (a, b) ->
          applySortOrder a[header.sortField].localeCompare b[header.sortField]

      headers: [
        new TableHeader
          name: 'Name'
          sortField: 'name'
          sortEnabled: 'ascending'

        new TableHeader
          name: 'Twitter'
          sortField: 'twitter'
          align: 'center'
      ]

    return
