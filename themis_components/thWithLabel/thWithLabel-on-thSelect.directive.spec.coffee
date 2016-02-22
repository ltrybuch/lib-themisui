context = describe

describe 'withLabel', ->
  element = null

  compileElement = ->
    additions =
      options: [{name: "first", value: 1}, {name: "second", value: 2}]
    compileDirective("""
      <th-select options="options" with-label="label name"></th-select>
    """, additions)

  context "with th-select", ->
    require('./sharedTests').testingPrependedLabel compileElement
