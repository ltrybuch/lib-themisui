angular.module("ThemisComponents")
  .factory "ModalManager", ($http, $q) ->
    modals = []

    show = (options = {}) ->
      {
        path = ""
        name = path
        params = ""
        context = {}
        template = null
        size = "medium"
      } = options

      deferred = $q.defer()
      modalPromise =
        if template?
          $q.when data: template
        else
          $http url: path, method: "GET", params: params

      modalPromise.then (response) ->
        addModal
          content: response.data
          name: name
          deferred: deferred
          context: context
          size: size
      deferred.promise

    confirm = (name, response) ->
      modal = findByName name
      modal.deferred.resolve(response) if modal isnt undefined
      remove name

    dismiss = (name, response) ->
      modal = findByName name
      remove name

    findByName = (name) ->
      index = modals.findIndex (element) -> element.name is name
      modals[index]

    remove = (name) ->
      index = modals.findIndex (element) -> element.name is name
      modals.splice index, 1 unless index is -1

    addModal = ({content, name, deferred, context, size}) ->
      if name isnt modals[0]?.name
        modals.push
          name: name
          content: content
          deferred: deferred
          context: context
          size: size

    return {
      show
      dismiss
      confirm
      _modals: modals
    }
