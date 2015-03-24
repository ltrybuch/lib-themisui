angular = require 'angular'

angular.module 'ThemisComponentsApp', [
  require 'angular-sanitize'
  require '../../' # requiring ThemisComponents
]

require './controllers'
