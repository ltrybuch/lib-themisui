angular.module('ThemisComponents')
  .factory 'ModalManager', ($http, $q) ->
    modals = []

    show = (path, params, name, options) ->
      options = options ? {}
      deferred = $q.defer()
      modalPromise = $http(url: path, method: "GET", params: params)
      modalPromise.then (response) ->
        addModal
          content: response.data
          name: name ? path
          deferred: deferred
          size: options.size
      deferred.promise

    confirm = (name, args) ->
      modal = findByName(name)
      modal.deferred.resolve(args) if modal isnt undefined
      removeModal(name)

    dismiss = (name) ->
      modal = findByName(name)
      modal.deferred.reject() if modal isnt undefined
      removeModal(name)

    findByName = (name) ->
      index = modals.findIndex (element) -> element.name is name
      modals[index]

    removeModal = (name) ->
      index = modals.findIndex (element) -> element.name is name
      modals.splice index, 1 unless index is -1

    addModal = ({content, name, deferred, size}) ->
      if name isnt modals[0]?.name
        modals.push
          name: name
          content: content
          deferred: deferred
          size: size

    return {
      show
      dismiss
      confirm
      _modals: modals
    }
