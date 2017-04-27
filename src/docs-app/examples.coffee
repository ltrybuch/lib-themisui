# A main entry file that is used to generate two artifacts
# that are used to drive the iframe examples
# 1) examples.js
# 2) examples.css
angular = require "angular"

require "./catalog/component-example/component-examples.scss"

if process and process.theme is "apollo"
  require "../lib/index.apollo.scss"
else
  require "../lib/index.themis.scss"

require "../lib/index"
require "../lib/index.examples"
