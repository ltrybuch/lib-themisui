angular = require 'angular'

angular.module 'ThemisComponentsApp', [
  require 'angular-route'
  require 'angular-sanitize'
  require '../../' # requiring ThemisComponents
]

require './initializeRoutes'
require './controllers'
