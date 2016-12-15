angular = require 'angular'

angular.module 'ThemisComponentsApp', [
  require 'angular-sanitize'
  require '../../lib/index.coffee' # requiring ThemisComponents
]

require './initializeRoutes'
require './controllers'
