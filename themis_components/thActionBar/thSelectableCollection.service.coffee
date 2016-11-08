angular.module("ThemisComponents")
  .factory "SelectableCollection", ($rootScope, ViewModel, $q, $timeout) ->
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
      selectedCount = 0
      processingCollection = no
      childrenLookup = {}
      trackedCollection = []

      selectableCollection.parent = parent
      selectableCollection.loadingIds = no
      selectableCollection.allIdentifiers = {}

      selectableCollection.resetSelected = ->
        trackedCollection.forEach (item) ->
          item.selected = false
          delete item.children

      selectableCollection.collectionValues = ->
        formattedCollection = []
        for item in trackedCollection
          childSelectableCollection = childrenLookup[item.id]

          if childSelectableCollection?
            childReturnItems = childSelectableCollection.collectionValues()
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
            selected: default: allSelected, evented: yes
            indeterminate: default: no, evented: yes

          model = viewModel.model
          Object.keys(model).forEach (property) ->

            if model[property].collection? # Child collection exists.
              childCollection = _makeChildSelectableCollection(model[property], viewModel)
              model[property] = childCollection # replace with new collection

              identifier = model[trackedBy]
              childrenLookup[identifier] = childCollection

          attachListener(viewModel)
          selectableCollection.push(viewModel)

          exists = trackedCollection.some (item) -> item.id is viewModel.model.id
          trackedCollection.push(id: viewModel.model.id, selected: allSelected) unless exists

        selectableCollection.parent?.emit "selectableCollectionUpdated"

      _makeChildSelectableCollection = (property, viewModel) ->
        collection = property.collection
        totalItemCount = property.meta.totalItems

        return SelectableCollection
          array: collection
          parent: viewModel
          retrieveIds: retrieveIds
          totalItems: totalItemCount

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

        if selectedCount is totalItems
          allSelected = yes
          unless processingCollection
            selectableCollection.parent?.view.selected = yes
        else
          allSelected = no
          unless processingCollection
            selectableCollection.parent?.view.selected = no

        if selectableCollection.parent?
          allSelected = selectableCollection.parent.view.selected

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
              if identifiers instanceof Array
                trackedCollection = identifiers.map (id) -> id: id, selected: false
              else
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

      _updateIndeterminateState = (viewModel) ->
        $timeout ->
          # Update the parent when the collection is partially selected
          # or a collection item has a child which is partailly selected.
          count = trackedCollection.reduce (count, item) ->
            if item.selected then ++count else count
          , 0
          isIndeterminate = viewModel.view.indeterminate or (count < totalItems and count > 0)
          selectableCollection.parent?.view.indeterminate = isIndeterminate
          $rootScope.$apply()

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
        viewModel.on "view:changed:indeterminate", (status) ->
          _updateIndeterminateState(this)

        viewModel.on "view:changed:selected", (selectionState) ->
          if selectionState then select(viewModel) else unselect(viewModel)

          _updateIndeterminateState(viewModel)

      _generateCollection(array)

      attachParentListener() if selectableCollection.parent

      return selectableCollection
