angular.module('ThemisComponents')
  .factory 'ModalManager', ($http) ->
    modals = []

    showModal = (path, params, name) ->
      modalPromise = $http(url: path, method: "GET", params: params)
      modalPromise.then (response) ->
        addModal
          content: response.data
          name: name ? path

    removeModal = (name) ->
      index = modals.findIndex (element) -> element.name is name
      modals.splice index, 1 unless index is -1

    addModal = ({content, name}) ->
      if name isnt modals[0]?.name
        modals.push
          name: name
          content: content

    return {
      showModal
      removeModal
      modals
    }
