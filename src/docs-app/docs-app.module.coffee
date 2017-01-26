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
