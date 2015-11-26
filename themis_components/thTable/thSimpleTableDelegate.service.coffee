angular.module 'ThemisComponents'
  .factory 'SimpleTableDelegate', (TableDelegate) ->
    class SimpleTableDelegate extends TableDelegate
      post: (rows) ->
        cellsRow = rows['cells']
        actionsRow = rows['actions']
        console.log cellsRow, actionsRow, @data
