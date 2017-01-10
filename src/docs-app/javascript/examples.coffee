angular = require "angular"
require "prismjs"
require "prismjs/components/prism-coffeescript"
require "prismjs/components/prism-json"
require "prismjs/plugins/line-numbers/prism-line-numbers"

require "../stylesheets/examples.scss"

angular.module "ThemisComponentsExample", [
  require "../../lib/index.coffee" # requiring ThemisComponents
]
