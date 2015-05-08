angular.module('ThemisComponents')
  .factory 'PopoverManager', ($q, $http, $timeout) ->
    popoverContent = {}

    templateFromURL = (templateURL) ->
      $q (resolve, reject) ->
        if popoverContent[templateURL]?
          resolve popoverContent[templateURL]
        else
          $http.get templateURL
          .then (response) ->
            popoverContent[templateURL] = response.data
            resolve popoverContent[templateURL]
          , ->
            reject "error"

    return {
      templateFromURL
    }