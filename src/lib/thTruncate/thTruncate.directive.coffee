angular.module('ThemisComponents')
  .directive 'thTruncate', ->
    restrict: 'E'
    transclude: true
    template: require './thTruncate.template.html'
    bindToController: true
    controllerAs: 'truncate'
    scope: {
      text: '@'
      limit: '=?'
      ngClick: '&'
    }
    controller: ($scope) ->
      # Remove line breaks and returns
      @formattedText = @text.replace(/\s\s+/g, '')
      @limit = @limit || 100
      @expanded = false
      @hasTruncateControl = if @formattedText.length >= @limit then yes else no

      truncate = =>
        if @expanded
          @formattedText
        else
          @formattedText.substring(0, @limit) +
          if @hasTruncateControl then '...' else ''

      @toggleTruncation = ->
        @expanded = !@expanded
        @truncatedText = truncate()

      @truncatedText = truncate()

      return
