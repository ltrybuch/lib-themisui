### Require Dependancies ###
#= require angular/angular
#= require angular-animate/angular-animate
#= require markdown/lib/markdown

#= require_self

### Require Components ###
#= require_directory ./thBindMarkdown
#= require_directory ./thComponentExample
#= require_directory ./thContextualMessage
#= require_directory ./thSwitch

modules = [
  'ngAnimate'
]

angular.module 'ThemisComponents', modules
