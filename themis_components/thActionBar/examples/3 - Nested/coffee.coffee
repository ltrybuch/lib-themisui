angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", ($scope, $q, ActionBarDelegate, $timeout) ->
    pageSize = 5
    @currentPage = 1

    @actionBarDelegate = new ActionBarDelegate
      retrieveIds: (viewObject) ->
        if viewObject.model.id is "root"
          $timeout ->
            $q.when Client.ids()
          , 200
        else
          Matter.ids viewObject.model.id

      onApply: ({trackedCollection, selectedAction}, triggerReset) =>
        @results = trackedCollection
        @selectedAction = selectedAction
        triggerReset()

      availableActions: [
        {name: "Print", value: "print"}
        {name: "Download Archive", value: "download"}
      ]
      collectionReferences: ["clients", "matters"]

    @showMore = (viewObject) ->
      # The viewmodel allows for access to it's collection.
      collection = viewObject.model.matters

      clientID = viewObject.model.id
      page = ++viewObject.model.currentMattersPage
      Matter.query(clientID: clientID, page: page).then (matters) ->
        $scope.$apply -> collection.addToSelectableCollection matters

    @updateClientData = ->
      apiData = Client.query page: @currentPage
      totalItems = apiData.meta.totalItems
      @totalPages = Math.ceil totalItems / pageSize
      @clients = @actionBarDelegate.makeSelectable apiData

    @goToPage = (page) =>
      @currentPage = page
      @updateClientData()

    @updateClientData()

    return

####################################################################################################
## SAMPLE DATA HERE. ##
currentID = 0
fixtures = (length) ->
  getRandomInt = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  capitalizeFirstLetter = (string) ->
    string[0].toUpperCase() + string[1 ..]

  generateName = ->
    possible = "abcdefghijklmnopqrstuvwxyz"
    length = getRandomInt 5, 10
    text = ""
    text += possible[getRandomInt 0, possible.length - 1] for i in [1 .. length]
    capitalizeFirstLetter text

  people = []
  for i in [1 .. length]
    people.push
      id: ++currentID
      firstName: generateName()
      lastName: generateName()
      email: generateName()

  return people

DBSOURCE = do ->
  clients = fixtures 24
  clients.forEach (client) ->
    client.matters = fixtures 15
    client.currentMattersPage = 1
  return clients

Client = {}
Client.query = ({limit = 5, pageSize = 5, page = 1}) ->
  start = (page - 1) * pageSize
  end = start + limit

  clients = JSON.parse JSON.stringify(DBSOURCE)
  clients = clients[start ... end]
  clients.forEach (client) ->
    client.matters = {collection: client.matters[0 ... 3], meta: totalItems: 15}
  return {
    collection: clients
    meta: totalItems: DBSOURCE.length
  }

Client.ids = ->
  clients = JSON.parse JSON.stringify(DBSOURCE)
  ids = {}
  for client in clients
    ids[client.id] = (matter.id for matter in client.matters)
  return ids

Matter = {}
Matter.query = ({clientID, limit = 3, offset = 3, page = 1}) ->
  start = (page - 1) * offset
  end = start + limit

  new Promise (resolve, reject) ->
    clients = JSON.parse JSON.stringify(DBSOURCE)
    found = clients.find (client) -> client.id is clientID
    setTimeout (-> resolve found.matters[start ... end]), 300

Matter.ids = (clientID) ->
  new Promise (resolve) ->
    found = DBSOURCE.find (client) -> client.id is clientID
    ids = {}
    ids[found.id] = (matter.id for matter in found.matters)
    resolve ids

####################################################################################################
## UNRELATED COMPONENT TO SET UP EXAMPLE ##
angular.module("thDemo")
  .component "ccPagination",
    controllerAs: "ccPagination"
    bindings:
      currentPage: "<"
      totalPages: "<"
      fetchPage: "<"
    template: """
      <div class="cc-pagination" ng-if="ccPagination.pages().length > 1">
        <a
          class="cc-pagination-link"
          ng-class="{'cc-pagination-inactive-link': ccPagination.isFirstPage()}"
          ng-click="ccPagination.goToPrevPage()"
          >
          <div class="fa fa-chevron-left cc-pagination-icon-left"></div>
          Previous
        </a>
        <a
          class="cc-pagination-link"
          ng-repeat="page in ccPagination.pages() track by $index"
          ng-click="ccPagination.goToPage(page)"
          ng-class="{'cc-pagination-inactive-link': ccPagination.inactivePageLink(page)}"
          >
          {{ page }}
        </a>
        <a
          class="cc-pagination-link"
          ng-class="{'cc-pagination-inactive-link': ccPagination.isLastPage()}"
          ng-click="ccPagination.goToNextPage()"
          >
          Next
          <div class="fa fa-chevron-right cc-pagination-icon-right"></div>
        </a>
      </div>
    """

    controller: ->
      ellipsis = "…"
      maxConsecutivePages = 5

      @isFirstPage = -> @currentPage is 1

      @isLastPage = -> @currentPage is @totalPages

      @inactivePageLink = (page) -> page in [@currentPage, ellipsis]

      @goToNextPage = -> @goToPage @currentPage + 1

      @goToPrevPage = -> @goToPage @currentPage - 1

      @goToPage = (page) ->
        return if page in [ellipsis, @currentPage]

        if page < 1
          page = 1
        else if @totalPages isnt 0 and page > @totalPages
          page = @totalPages

        return if page is @currentPage

        @fetchPage page

      @pages = ->
        return [] unless @totalPages and @totalPages > 0
        start = end = 0
        lastPage = @totalPages

        # 4 here means:
        #  - 1 and ellipsis at the beginning
        #  - ellipsis and lastPage at the end
        if lastPage <= maxConsecutivePages + 4
          return [1 .. lastPage]

        if maxConsecutivePages % 2 is 0
          start = @currentPage - maxConsecutivePages / 2 + 1
          end = @currentPage + maxConsecutivePages / 2
        else
          start = @currentPage - Math.floor maxConsecutivePages / 2
          end = @currentPage + Math.floor maxConsecutivePages / 2

        if start < 3
          # We don't need to display an ellipsis after 1
          end = Math.max maxConsecutivePages, end
          return [1 .. end].concat [ellipsis, lastPage]

        if end > lastPage - 2
          # We don't need to display an ellipsis before lastPage
          start = Math.min lastPage - maxConsecutivePages + 1, start
          return [1, ellipsis].concat [start .. lastPage]

        return [1, ellipsis]
          .concat [start .. end]
          .concat [ellipsis, lastPage]

      return
