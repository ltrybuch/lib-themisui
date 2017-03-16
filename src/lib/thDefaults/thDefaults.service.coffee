angular.module 'ThemisComponents'
  .factory 'thDefaults', ->
    defaults = {
      dateFormat: "yyyy-MM-dd"
    }

    setSingleKey = (key, value) ->
      defaults[key] = value

    setBulkKeys = (collection) ->
      Object.keys(collection).forEach (key) ->
        value = collection[key]
        setSingleKey key, value

    # Accept generic `set` call and route to the appropriate function.
    set = ->
      if arguments[0]? \
        and arguments[1]? \
        and typeof arguments[0] is "string"
          setSingleKey arguments[0], arguments[1]
      else if arguments[0]? \
        and arguments[0] instanceof Object
          setBulkKeys arguments[0]
      else
        new Error "Unknow parameter types."

    entries = ->
      return defaults

    get = (key) ->
      return defaults[key]

    return Object.freeze {
      set
      get
      entries
    }
