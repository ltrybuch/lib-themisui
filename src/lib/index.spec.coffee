require "angular"
require "angular-mocks"
require "whatwg-fetch"
require "./index"

specContext = require.context "./", true, /spec$/
specContext.keys().forEach (path) ->
  try
    specContext path
  catch error
    console.error "[ERROR] WITH SPEC FILE: ", path
    console.error error
