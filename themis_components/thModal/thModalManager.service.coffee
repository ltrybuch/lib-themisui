angular.module('ThemisComponents')
  .factory 'ModalManager', ($http, $q) ->
    modals = []

    showModal = ({path, name, params} = {}) ->
      path ?= ""; name ?= path; params ?= "" # set defaults

      deferred = $q.defer()
      modalPromise = $http(url: path, method: "GET", params: params)
      modalPromise.then (response) ->
        addModal
          content: response.data
          name: name
          deferred: deferred
      deferred.promise

    confirm = (name, response) ->
      modal = findByName(name)
      modal.deferred.resolve(response) if modal isnt undefined
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

    addModal = ({content, name, deferred}) ->
      if name isnt modals[0]?.name
        modals.push
          name: name
          content: content
          deferred: deferred

    return {
      showModal
      dismiss
      confirm
      _modals: modals
    }
