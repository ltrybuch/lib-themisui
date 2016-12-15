angular.module 'ThemisComponents'
  .factory 'ActionBarDelegate', (ViewModel, SelectableCollection) ->
    ActionBarDelegate = (options = {}) ->
      {
        retrieveIds
        onApply
        availableActions
        collectionReferences
      } = options

      unless onApply instanceof Function
        throw new Error(
          "ActionBarDelegate needs to be passed the following function: onAction"
        )

      unless retrieveIds instanceof Function
        throw new Error(
          "ActionBarDelegate needs to be passed the following function: retrieveIds"
        )

      unless collectionReferences instanceof Array
        throw new Error(
          "ActionBarDelegate needs to be passed the following array: collectionReferences"
        )

      updatingSelections = no
      ref = {}
      sourceOfTruth = {} # A dictionary of all view model selected values.
      results = {}
      results.totalItemCount = 0

      _initializeDelegate = ->
        _resetResultsObject(results)
        _generateCollectionReferences()

      makeSelectable = (data) ->
        parentModel = {id: "root"}
        parentModel[ref.parents] = data

        results.totalItemCount = data.meta.totalItems

        selectableCollection = new SelectableCollection
          array: [parentModel]
          totalItems: data.meta.totalItems
          retrieveIds: retrieveIds

        results.actionBarModel = selectableCollection[0]
        results.actionBarModel.view.selected = results.allSelected
        results.actionBarModel.on "selectableCollection:fetchingIds", (status) ->
          results.loadingIds = status

        results.actionBarModel.model[ref.parents].forEach (viewModel) ->
          _updateSelectedStatus viewModel unless results.allSelected
          _attachListeners viewModel

        results.actionBarModel.on "selectableCollection:allSelected", (status) ->
          _updateSourceOfTruth() unless updatingSelections
          results.allSelected = no unless status
          results.selectedItemCount = _getSelectedItemCount()

        return results.actionBarModel.model[ref.parents]

      evaluateOnApplyFunction = ->
        onApply
          trackedCollection: _returnCollection()
          selectedAction: results.selectedAction?.value
          ->
            triggerReset()

      triggerReset = ->
        _resetResultsObject(results)
        sourceOfTruth = {}

      _attachListeners = (viewModel) ->
        model = viewModel.model
        _attachListener viewModel

        Object.keys(model).forEach (key) ->
          if model[key] instanceof Array
            _attachListenerToNested vm for vm in model[key]
            _attachListenersOnCollectionChange viewModel, model[key]

      _updateSelectedStatus = (viewModel) ->
        existingItemInSourceOfTruth = sourceOfTruth[viewModel.model.id]
        if existingItemInSourceOfTruth
          updatingSelections = yes

          # Update parent model selected value.
          viewModel.view.selected = existingItemInSourceOfTruth.selected

          if existingItemInSourceOfTruth.children and viewModel.view.selected is false
            # Iterate over the view model's children update their selected value with our value.
            viewModelChildren = viewModel.model[ref.children]

            for childOfViewModel in viewModelChildren
              for childOfExistingItem in existingItemInSourceOfTruth.children

                # If a view model's children are not all selected but some are then
                # we'll need to update the view model's indeterminate state to be true.
                hasSelectedChildren = existingItemInSourceOfTruth.children.some (each) ->
                  each.selected
                viewModel.view.indeterminate = hasSelectedChildren

                if childOfViewModel.model.id is childOfExistingItem.id
                  childOfViewModel.view.selected = childOfExistingItem.selected

        updatingSelections = no

      _updateSourceOfTruth = ->

        # This will only work for a depth of 2
        _updateChildren = (originalItem, updatedItem) ->
          if originalItem? and originalItem.children? and updatedItem.children?
            originalItem.children.forEach (child) ->
              childExists = updatedItem.children?.some (item) -> item.id is child.id
              unless childExists
                sourceOfTruth[originalItem.id].children.push child if child.selected

        updatedvalues =
          results.actionBarModel.model[ref.parents].collectionValues()

        if updatedvalues?
          updatedvalues.forEach (item) ->
            originalItem = sourceOfTruth[item.id]
            updatedItem = sourceOfTruth[item.id] = item

             # Update the children as well.
            _updateChildren(originalItem, updatedItem)

      _attachListenersOnCollectionChange = (viewModel, collection) ->
        # TODO: Replace this event name format with the emerging "foo:barXyz"
        viewModel.on "selectableCollectionUpdated", ->
          _updateSelectedStatus(this)

          # For new incoming view models we need to set up listeners.
          for viewModel in collection
            existingListener = viewModel.listeners("view:changed:selected")[1]
            _attachListenerToNested viewModel unless existingListener

      _attachListener = (viewModel) ->
        viewModel.on "view:changed:selected", (status) ->

          _updateSourceOfTruth() unless updatingSelections
          results.allSelected = no unless status

          results.selectedItemCount = _getSelectedItemCount()

          if results.selectedItemCount is results.totalItemCount
            results.allSelected = yes

          if results.allSelected
            results.selectedItemCount = results.totalItemCount

      _attachListenerToNested = (viewModel) ->
        viewModel.on "view:changed:selected", (status) ->
          _updateSourceOfTruth() unless updatingSelections
          results.allSelected = no unless status
          results.selectedItemCount = _getSelectedItemCount()

      _getSelectedItemCount = ->
        itemCount = 0
        for key, parent of sourceOfTruth

          aChildIsSelected = parent.children?.some (child) -> child.selected
          parentIsSelected = parent.selected

          if parentIsSelected or aChildIsSelected then ++itemCount
        return itemCount

      _generateCollectionReferences = ->
        # Let's set up references to property for the incoming collection data.
        generations = 0: "parents", 1: "children"
        ref[generations[index]] = reference for reference, index in collectionReferences

      _resetResultsObject = (results) ->
        if results.actionBarModel?
          # Trigger reset of actionbar's collection
          results.actionBarModel.model[ref.parents].resetSelected()

          for parent in results.actionBarModel.model[ref.parents]
            children = parent.model[ref.children]
            parent.view.selected = no

            if children? # Reset children's selected values if children
              child.view.selected = no for child in children

        results.selectedItemCount = 0
        results.availableActions = availableActions
        results.allSelected = no
        results.processing = no
        results.selectedAction = null
        results.loadingIds = no

      _returnCollection = ->
        currentPageItems = results.actionBarModel.model[ref.parents].length

        # Spanning more than one page. We need to get all the ids.
        if results.selectedItemCount >= currentPageItems
          _fetchAllValues()
          _returnSelectedValues()
        else
          _returnSelectedValues()

      _fetchAllValues = ->
        allIdentifiers = results.actionBarModel.model[ref.parents].allIdentifiers
        for key of sourceOfTruth
          parent = sourceOfTruth[key]
          childrenIds = allIdentifiers[parent.id]

          unless parent.children?
            if childrenIds?.length > 0
              parent.children = childrenIds.map (id) -> {id: id, selected: parent.selected}

      _returnSelectedValues = ->

        filterUnselected = (item, referenceNameIndex) ->
          generationName = collectionReferences[referenceNameIndex]
          selectedItem = null

          if item.children?
            filteredChildCollection = []
            for child in item.children
              selectedChild = filterUnselected(child, referenceNameIndex + 1)
              filteredChildCollection.push selectedChild if selectedChild?

            if filteredChildCollection.length > 0
              selectedItem = {id: item.id, selected: item.selected}
              selectedItem[generationName] = filteredChildCollection

          else
            selectedItem = {id: item.id, selected: item.selected} if item.selected

          return selectedItem

        onlySelected = []
        for key of sourceOfTruth
          item = sourceOfTruth[key]
          selectedItem = filterUnselected item, 1
          onlySelected.push selectedItem if selectedItem?


        return onlySelected

      _initializeDelegate() # Bootstrap our delegate

      return Object.freeze {
        results
        makeSelectable
        evaluateOnApplyFunction
        triggerReset
      }
