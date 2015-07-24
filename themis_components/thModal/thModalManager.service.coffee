angular.module('ThemisComponents')
  .factory 'ModalManager', ($http) ->
    modals = []
    queue = []

    showModal = (name) ->
      index = queue.findIndex (element) -> element.name is name
      modals.push queue[index] unless index is -1

    removeModal = (name) ->
      index = modals.findIndex (element) -> element.name is name
      modals.splice index, 1 unless index is -1

    add = (path, params, name) ->
      $http(url: path, method: "GET", params: params).then (response) ->
        addToQueue
          name: name
          content: response.data

    addToQueue = ({name, content}) ->
      if name isnt queue[0]?.name
        queue.push
          name: name ? path
          content: content
    return {
      add
      addToQueue
      showModal
      removeModal
      modals
    }
