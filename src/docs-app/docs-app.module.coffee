require "prismjs"
require "prismjs/components/prism-coffeescript"
require "prismjs/components/prism-typescript"
require "prismjs/components/prism-json"
require "prismjs/plugins/line-numbers/prism-line-numbers"
angular = require "angular"

angular.module "ThemisComponentsApp", [
  require "angular-sanitize"
  require("angular-ui-router").default
  require "../lib/index" # requiring ThemisComponents
]

require "./docs-app/docs-app"
require "./routes"
require "./catalog"
require "./documentation"
