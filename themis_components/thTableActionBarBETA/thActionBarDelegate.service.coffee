angular.module 'ThemisComponents'
  .factory 'ActionBarDelegateBETA', (ViewModel, SelectableCollection) ->
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
      totalItemCount = 0
      ref = {}
      sourceOfTruth = {} # A dictionary of all view model selected values.
      results = {}

      _initializeDelegate = ->
        _resetResultsObject(results)
        _generateCollectionReferences()

      makeSelectable = (data) ->
        parentModel = {id: "root"}
        parentModel[ref.parents] = data

        totalItemCount = data.meta.totalItems

        selectableCollection = new SelectableCollection
          array: [parentModel]
          totalItems: data.meta.totalItems
          retrieveIds: retrieveIds

        results.actionBarModel = selectableCollection[0]
        results.actionBarModel.view.selected = results.allSelected

        results.actionBarModel.model[ref.parents].forEach (viewModel) ->
          _updateSelectedStatus viewModel unless results.allSelected
          _attachListeners viewModel

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
                if childOfViewModel.model.id is childOfExistingItem.id
                  childOfViewModel.view.selected = childOfExistingItem.selected

        updatingSelections = no

      _updateSourceOfTruth = ->
        updatedvalues = results.actionBarModel.model[ref.parents].getSelected()

        # This will only work for a depth of 2
        if updatedvalues?
          updatedvalues.forEach (item) ->
            oldItemSourceOfTruth = sourceOfTruth[item.id]
            sourceOfTruth[item.id] = item
            if (oldItemSourceOfTruth? and
              oldItemSourceOfTruth.children? and
              sourceOfTruth[item.id].children?)
                oldItemSourceOfTruth.children.forEach (child) ->
                  childExists = sourceOfTruth[item.id].children?.some (item) ->
                    item.id is child.id
                  unless childExists
                    sourceOfTruth[item.id].children.push child if child.selected

      _attachListenersOnCollectionChange = (viewModel, collection) ->
        viewModel.on "selectableCollectionUpdated", ->
          _updateSelectedStatus(this)

          # For new incoming view models we need to set up listeners.
          for viewModel in collection
            existingListener = viewModel.listeners("view:changed:selected")[1]
            unless existingListener
              _attachListenerToNested viewModel
              ++results.selectedItemCount if viewModel.view.selected

      _attachListener = (viewModel) ->
        viewModel.on "view:changed:selected", (status) ->
          unless updatingSelections
            _updateSourceOfTruth()
          if status
            ++results.parentSelectedItemCount
          else
            --results.parentSelectedItemCount
            results.allSelected = no

          if results.parentSelectedItemCount is totalItemCount
            results.allSelected = yes

          if results.allSelected
            results.parentSelectedItemCount = totalItemCount

      _attachListenerToNested = (viewModel) ->
        viewModel.on "view:changed:selected", (status) ->
          _updateSourceOfTruth() unless updatingSelections
          if status
            ++results.selectedItemCount
          else
            --results.selectedItemCount

      _generateCollectionReferences = ->
        # Let's set up references to property for the incoming collection data.
        generations = 0: "parents", 1: "children"
        ref[generations[index]] = reference for reference, index in collectionReferences

      _resetResultsObject = (results) ->
        if results.actionBarModel?
          # Trigger reset of actionbar's collection
          results.actionBarModel.model[ref.parents].resetSelected()

          for parent in results.actionBarModel.model[ref.parents]
            parent.view.selected = no
            children.view.selected = no for children in parent.model[ref.children]

        results.selectedItemCount = 0
        results.parentSelectedItemCount = 0
        results.availableActions = availableActions
        results.allSelected = no
        results.processing = no
        results.selectedAction = null

      _returnCollection = ->
        currentPageItems = results.actionBarModel.model[ref.parents].length

        # Spanning more than one page. We need to get all the ids.
        if results.parentSelectedItemCount >= currentPageItems
          _fetchAllValue()
          _returnSelectedValues()
        else
          _returnSelectedValues()

      _fetchAllValue = ->
        allIdentifiers = results.actionBarModel.model[ref.parents].allIdentifiers
        for key of sourceOfTruth
          parent = sourceOfTruth[key]
          childrenIds = allIdentifiers[parent.id]
          unless parent.children?
            if childrenIds.length > 0
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
