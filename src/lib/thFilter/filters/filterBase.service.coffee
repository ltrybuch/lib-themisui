angular.module "ThemisComponents"
.factory "FilterBase", ->
  class FilterBase
    constructor: (options = {}) ->
      {
        @fieldIdentifier
        @name
        @metadata
      } = options

    getState: ->
      throw new Error "FilterBase: Subclass '#{@type}' must implement " + \
                      "'getState'."

    getMetadata: -> @metadata
