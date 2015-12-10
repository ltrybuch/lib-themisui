angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader) ->
    celebrities = [
      {name: "Jose Valim",  twitter: "josevalim"}
      {name: "Dan Abramov", twitter: "dan_abramov"}
      {name: "Todd Motto",  twitter: "toddmotto"}
      {name: "Yehuda Katz", twitter: "wycats"}
      {name: "Paul Graham", twitter: "paulg"}
    ]

    repeat = (array, times) ->
      if times is 1
        array
      else
        array.concat repeat(array, times - 1)

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

    viewObject = (object) ->
      return {
        selected: isSelected object
        object
      }

    @selectedObjects = []

    isSelected = (object) =>
      if @selectedObjects.find((o) -> o is object) then true else false

    @toggleSelected = (viewObject) =>
      idx = @selectedObjects.indexOf viewObject.object
      if idx isnt -1
        @selectedObjects.splice idx, 1
      else
        @selectedObjects.push viewObject.object

    data = repeat(celebrities, 5).map twitterUser

    pageSize = 2
    initialData = data
                    .map viewObject
                    .sort (a, b) -> a.object.name.localeCompare b.object.name
                    .slice 0, pageSize

    @tableDelegate = new SimpleTableDelegate
      data: initialData

      page: 1
      pageSize: pageSize
      totalItems: data.length
      onChangePage: (page, next) ->
        skip = (page - 1) * pageSize
        next(data
              .slice skip, skip + pageSize
              .map viewObject
              )

      headers: [
        new TableHeader
          name: ''

        new TableHeader
          name: 'Id'

        new TableHeader
          name: 'Name'
          sortField: 'object.name'
          sortEnabled: 'ascending'

        new TableHeader
          name: 'Income'
          align: 'right'

        new TableHeader
          name: 'Twitter'
          sortField: 'object.twitter'
      ]

    return
