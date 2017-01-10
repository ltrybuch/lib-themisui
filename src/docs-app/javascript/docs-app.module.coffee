angular = require "angular"
require "prismjs"
require "prismjs/components/prism-coffeescript"
require "prismjs/components/prism-json"
require "prismjs/plugins/line-numbers/prism-line-numbers"

require "../stylesheets/docs-app.scss"

angular.module 'ThemisComponentsApp', [
  require 'angular-sanitize'
  require '../../lib/index.coffee' # requiring ThemisComponents
]

require "./initializeRoutes"
require "./controllers"
require './components/bind-markdown'
require './components/component-example'
