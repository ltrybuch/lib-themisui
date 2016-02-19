context = describe

describe 'withLabel', ->
  element = null

  compileElement = ->
    compileDirective("""<th-input with-label="label name"></th-input>""")

  context 'with th-input example', ->
    require('./sharedTests').testingPrependedLabel compileElement
