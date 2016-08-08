angular.module 'ThemisComponents'
  .factory 'ActionBarDelegate', ($rootScope, ViewModel) ->
    ActionBarDelegate = (options = {}) ->
      {
        onApply
        availableActions
        pageSize
        trackBy = "id"
      } = options

      unless onApply instanceof Function
        throw new Error(
          "ActionBarDelegate needs to be passed the following function: onAction"
        )

      unless availableActions instanceof Array
        throw new Error(
          "ActionBarDelegate needs to be passed the following array: availableActions"
        )

      currentPage = 1
      # Used to update viewmodels When entire collection is requested.
      # When set to true any incoming items will be set to selected when
      # converted to view models.
      selectAllFlag = no
      pageArrays = {}
      viewModels = []
      currentPageItemIdentifiers = []
      unselectedItemIdentifiers = []
      selectedItemIdentifiers = []
      selectedAction = null

      results =
        pageSize: pageSize ? 0
        totalItemCount: 0
        selectedItemCount: 0
        availableActions: availableActions
        processing: no
        isCurrentPageSelected: no

      makeSelectable = ({data = [], totalItems = 0, currentPage = 1, resetSelection = no}) ->
        _resetInternalCollections() if resetSelection

        viewModels = data.map (model) ->
          new ViewModel(model, {selected: false})

        pageArrays[currentPage] = viewModels.map (viewModel) ->
          if selectAllFlag
            unless unselectedItemIdentifiers.includes viewModel.model[trackBy]
              _addItemToSelectedItems viewModel.model[trackBy]

          return viewModel.model[trackBy]

        _updateViewModels()
        currentPage = currentPage
        results.totalItemCount = totalItems
        currentPageItemIdentifiers = pageArrays[currentPage]
        results.isCurrentPageSelected = _isCurrentPageSelected()

        return viewModels

      toggleSelected = (viewObject) ->
        currentlySelected = viewObject.model[trackBy]

        if _isSelected currentlySelected
          _addItemToUnselectedItems currentlySelected
          _removeItemFromSelectedItems currentlySelected

        else
          _addItemToSelectedItems currentlySelected
          _removeItemFromUnselectedItems currentlySelected
          ++results.selectedItemCount

        viewObject.view.selected = _isSelected(viewObject.model[trackBy])

        $rootScope.$apply ->
          results.isCurrentPageSelected = _isCurrentPageSelected()

      clearEntireCollection = ->
        # if "Clear all" is clicked the we need to reset all collections.
        _resetInternalCollections()
        selectAllFlag = no

        results.isCurrentPageSelected = no
        _updateViewModels()

      clearPage = ->
        currentPageItemIdentifiers.forEach (item) ->
          _removeItemFromSelectedItems item
          _addItemToUnselectedItems item

        results.isCurrentPageSelected = no
        _updateViewModels()


      selectPage = ->
        currentPageItemIdentifiers.forEach (item) ->
          unless selectedItemIdentifiers.includes item
            ++results.selectedItemCount

          _addItemToSelectedItems item
          _removeItemFromUnselectedItems item

        results.isCurrentPageSelected = yes
        _updateViewModels()


      selectEntireCollection = ->
        # If "Select all" is clicked we need the entire collection to be set
        # to 'selected'. We'll do that by setting `selectAllFlag` to true
        # so all incoming new pages will be 'selected' when processing them.

        # Here we are clearing all the collections and then updating the current
        # page's collection to be selected. Then setting the selected count to
        # the total item count.
        _resetInternalCollections()
        selectAllFlag = yes

        currentPageItemIdentifiers.forEach (item) ->
          _addItemToSelectedItems item
          _removeItemFromUnselectedItems item

        results.selectedItemCount = results.totalItemCount
        results.isCurrentPageSelected = yes
        _updateViewModels()

      setSelectedAction = (action) ->
        if action?.value
          selectedAction = action.value
        else
          selectedAction = ""

      evaluateOnApplyFunction = ->
        onApply
          trackedCollection: _appropriateCollection()
          allSelected: selectAllFlag
          selectedAction: selectedAction
          ->
            _resetInternalCollections()
            selectAllFlag = no

      _isCurrentPageSelected = ->
        return no if currentPageItemIdentifiers.length is 0
        pageSelectedCount = currentPageItemIdentifiers.reduce (count, item) ->
          if _isSelected item then ++count else count
        , 0
        return pageSelectedCount is currentPageItemIdentifiers.length

      _updateTotalItemCount = (count) -> results.totalItemCount = count

      _resetInternalCollections = ->
        _resetSelectedItems()
        _resetUnselectedItems()

      _resetSelectedItems = ->
        selectedItemIdentifiers.length = 0
        results.selectedItemCount = 0
        results.isCurrentPageSelected = no
        results.processing = no

        _updateViewModels()

      _resetUnselectedItems = -> unselectedItemIdentifiers.length = 0

      _appropriateCollection = ->
        if selectAllFlag
          unselectedItemIdentifiers.slice 0
        else
          selectedItemIdentifiers.slice 0

      _addItemToSelectedItems = (item) ->
        alreadyIncluded = selectedItemIdentifiers.includes item
        selectedItemIdentifiers.push item unless alreadyIncluded

      _addItemToUnselectedItems = (item) ->
        alreadyIncluded = unselectedItemIdentifiers.includes item
        unselectedItemIdentifiers.push item unless alreadyIncluded

      _removeItemFromSelectedItems = (item) ->
        index = selectedItemIdentifiers.indexOf item
        if index isnt -1
          selectedItemIdentifiers.splice index, 1
          --results.selectedItemCount

      _removeItemFromUnselectedItems = (item) ->
        index = unselectedItemIdentifiers.indexOf item
        unselectedItemIdentifiers.splice index, 1 if index isnt -1

      _isSelected = (item) -> item in selectedItemIdentifiers

      _updateViewModels = ->
        viewModels.forEach (viewObject) ->
          viewObject.view.selected = _isSelected(viewObject.model[trackBy])

      return Object.freeze {
        results
        setSelectedAction
        makeSelectable
        toggleSelected
        evaluateOnApplyFunction
        selectEntireCollection
        selectPage
        clearEntireCollection
        clearPage
      }
