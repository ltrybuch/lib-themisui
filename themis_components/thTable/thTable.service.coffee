angular.module 'ThemisComponents'
  .factory 'Table', ->
    class Table
      constructor: (element) ->
        @element = element
        throw new Error "<th-table> not properly configured!" unless @isProperlyDefined()
        @rows = @getRows()

      post: (delegate) ->
        delegate.post @rows

      clear: ->
        child.remove() for child in @element.children()

      getRows: ->
        rows = {}
        for row in @element.children()
          type = row.getAttribute 'type'
          rows[type] = row
        rows

      isProperlyDefinedRow: (node) ->
        node.tagName == 'TH-TABLE-ROW' and node.hasAttribute 'type'

      isProperlyDefined: ->
        children = @element.children()
        idx = 0
        while idx < children.length and @isProperlyDefinedRow children[idx]
          idx++
        return idx == children.length
