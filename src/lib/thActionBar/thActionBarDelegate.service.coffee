angular.module "ThemisComponents"
  .factory "ActionBarDelegate", (ViewModel) ->
    ActionBarDelegate = (options) ->
      selectingCollection = no
      pageCollection = []
      results =
        allSelected: no
        hasSelection: no
        selectedAction: null
        processing: no

      {
        buttonName = "Apply"
        availableActions
        onApply = -> return
      } = options

      makeSelectable = (collection) ->
        # Lets completely clear out our old data and listeners.
        destroy()
        reset()

        pageCollection = collection.map (each) ->
          new ViewModel each,
            selected: default: false, evented: true

        setUpListeners()

        return pageCollection

      toggleAll = (state) ->
        selectingCollection = yes
        pageCollection.forEach (vm) -> vm.view.selected = state
        results.allSelected = state
        selectingCollection = no

      setUpListeners = ->
        pageCollection.forEach (vm) ->
          vm.on "view:changed:selected", (state) ->

            selectedCount = pageCollection.reduce (count, vm) ->
              if vm.view.selected then ++count else count
            , 0

            results.hasSelection = selectedCount > 0

            unless selectingCollection
              results.allSelected = selectedCount is pageCollection.length

      destroy = ->
        pageCollection.forEach (vm) ->
          vm.removeAllListeners()
        pageCollection = []

      reset = ->
        results.allSelected = no
        results.processing = no
        results.hasSelection = no
        results.selectedAction = null

        pageCollection.forEach (vm) ->
          vm.view.selected = no

      isDisabled = ->
        actionsExist = not not availableActions
        results.processing or (not results.selectedAction and actionsExist)

      triggerApply = ->
        results.processing = yes
        ids = pageCollection
                .filter (vm) -> vm.view.selected
                .map (vm) -> vm.model.id

        values = ids: ids
        if availableActions?
          values.selectedAction = results.selectedAction.value

        onApply(values, reset)

      return {
        availableActions
        buttonName
        isDisabled
        makeSelectable
        results
        toggleAll
        triggerApply
      }
