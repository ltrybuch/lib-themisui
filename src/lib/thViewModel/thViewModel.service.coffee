EventEmitter = require 'events'

angular.module 'ThemisComponents'
  .factory 'ViewModel', ->
    class ViewModel extends EventEmitter
      constructor: (model, viewProperties = {}) ->
        @view = {}
        @model = model

        Object.keys(viewProperties).forEach (propertyKey) =>
          propertySettings = viewProperties[propertyKey]
          propertyDefault = propertySettings.default

          if propertySettings.evented
            property = {value: propertyDefault}

            Object.defineProperty @view, propertyKey,
              get: -> property.value
              set: (newValue) =>
                if newValue isnt property.value
                  property.value = newValue
                  @.emit "view:changed:#{propertyKey}", property.value
          else
            @view[propertyKey] = propertyDefault
