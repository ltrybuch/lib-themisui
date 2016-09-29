EventEmitter = require "events"

angular.module("ThemisComponents")
  .factory "SelectableCollection", (ViewModel, $q) ->
    SelectableCollection = (params = {}) ->
      {
        array = []
        trackedBy = "id"
        totalItems = array.length
        parent = null
        retrieveIds
      } = params
      selectableCollection = []
      allSelected = no
      processingCollection = no
      childrenLookup = {}
      trackedCollection = []

      selectableCollection.parent = parent
      selectableCollection.totalItems = totalItems
      selectableCollection.allSelected = allSelected
      selectableCollection.selectedCount = 0
      selectableCollection.loadingIds = no
      selectableCollection.allIdentifiers = {}

      selectableCollection.resetSelected = ->
        trackedCollection.forEach (item) ->
          item.selected = false
          delete item.children

      selectableCollection.getSelected = ->
        formattedCollection = []
        for item in trackedCollection
          childSelectableCollection = childrenLookup[item.id]

          if childSelectableCollection?
            childReturnItems = childSelectableCollection.getSelected()
            clonedItem = JSON.parse(JSON.stringify(item))
            clonedItem.children = childReturnItems
            formattedCollection.push clonedItem
          else
            formattedCollection.push item

        return formattedCollection

      selectableCollection.addToSelectableCollection = (array) ->
        _generateCollection(array)

      _generateCollection = (data) ->
        data.forEach (model) ->
          viewModel = new ViewModel model,
            selected: default: allSelected, evented: true

          viewModel.model = _generateNestedCollections(viewModel)

          attachListener(viewModel)
          selectableCollection.push(viewModel)
          exists = trackedCollection.some (item) -> item.id is viewModel.model.id
          trackedCollection.push(id: viewModel.model.id, selected: allSelected) unless exists

        selectableCollection.parent?.emit "selectableCollectionUpdated"

      _generateNestedCollections = (viewModel) ->
        model = viewModel.model
        Object.keys(model).forEach (key) ->
          if model[key].collection?

            collection = model[key].collection
            identifier = model[trackedBy]
            totalItemCount = model[key].meta.totalItems

            selectableChildCollection = SelectableCollection
              array: collection
              parent: viewModel
              retrieveIds: retrieveIds
              totalItems: totalItemCount

            model[key] = selectableChildCollection
            childrenLookup[identifier] = selectableChildCollection

        return model

      _isSelected = (viewModel) ->
        identifier = viewModel.model[trackedBy]
        return trackedCollection.some (item) -> item.id is identifier and item.selected

      _addToTracked = (viewModel) ->
        unless _isSelected(viewModel)
          identifier = viewModel.model[trackedBy]
          existingItem = trackedCollection.find (item) -> item.id is identifier
          if existingItem
            existingItem.selected = true
          else
            trackedCollection.push id: identifier, selected: true

      _removeFromTracked = (viewModel) ->
        identifier = viewModel.model[trackedBy]
        trackedCollection.forEach (item) -> item.selected = no if item.id is identifier

      _updateSelectAllStatus = ->
        selectedCount = trackedCollection.reduce (count, item) ->
          if item.selected then ++count else count
        , 0

        selectableCollection.selectedCount = selectedCount

        if selectedCount is totalItems
          allSelected = yes
          unless processingCollection
            selectableCollection.parent?.view.selected = yes
        else
          allSelected = no
          unless processingCollection
            selectableCollection.parent?.view.selected = no

      _updateViewModel = (viewModel) -> viewModel.view.selected = _isSelected(viewModel)

      select = (viewModel) ->
        _addToTracked viewModel
        _updateViewModel viewModel
        _updateSelectAllStatus()

      unselect = (viewModel) ->
        _removeFromTracked viewModel
        _updateViewModel viewModel
        _updateSelectAllStatus()

      selectAll = ->
        processingCollection = yes
        trackedCollection.forEach (item) -> item.selected = yes
        selectableCollection.forEach (viewModel) -> select viewModel
        processingCollection = no

      clearAll = ->
        processingCollection = yes
        selectableCollection.forEach (viewModel) ->
          unselect viewModel
        trackedCollection.forEach (item) -> item.selected = no
        processingCollection = no

      fetchAllChildrenIdentifiers = (viewObject) ->
        $q (resolve, reject) ->
          return retrieveIds(viewObject).then (identifiers) ->
            trackedCollection = []

            # the return ids are ALL ids so this parent collection on requires the keys.
            # Example {1: [1,2,3], 2: [2,3,4], 3: [6,7,8]}
            if selectableCollection.parent.model.id is "root"
              for key of identifiers
                id = parseInt(key, 10)
                trackedCollection.push id: id, selected: false

              # We'll keep a cache of these in case all are requested.
              selectableCollection.allIdentifiers = identifiers

            # the return ids here are a specific children collection's ids thus only one property.
            # example {4: [8,10,23]}
            else
              for key of identifiers
                children = identifiers[key]
                for id in children
                  trackedCollection.push id: id, selected: false

            resolve()

      attachParentListener = ->
        selectableCollection.parent.on "view:changed:selected", (selectionState) ->
          viewObject = this
          unless selectionState
            clearAll() if selectionState isnt allSelected

          if selectionState
            viewObject.emit "selectableCollection:fetchingIds", true

            fetchAllChildrenIdentifiers(this).then ->
              selectAll()
              viewObject.emit "selectableCollection:fetchingIds", false

      attachListener = (viewModel) ->
        viewModel.on "view:changed:selected", (selectionState) ->
          if selectionState then select(viewModel) else unselect(viewModel)

      _generateCollection(array)

      attachParentListener() if selectableCollection.parent

      return selectableCollection
