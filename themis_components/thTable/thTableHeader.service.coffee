angular.module 'ThemisComponents'
  .factory 'TableHeader', ->
    class TableHeader
      constructor: (options) ->
        @name = options.name or ""
        @sortField = options.sortField if options.sortField?
        @sortEnabled = options.sortEnabled
        @align = options.align or "left"

        if @sortEnabled and @sortEnabled not in ["ascending", "descending"]
          throw new Error "sortEnabled can be either ascending or descending"

        if @align not in ["left", "center", "right"]
          throw new Error "align can be one of: left, center or right"

      cssClasses: ->
        classes = []

        if @sortField?
          classes.push 'th-table-sortable'

        if @sortEnabled
          classes.push "th-table-sort-" + @sortEnabled
        else if @sortField?
          classes.push "th-table-sort-none"

        classes.push "th-table-align-" + @align

        classes.join ' '
