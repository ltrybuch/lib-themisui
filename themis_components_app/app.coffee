### Bower Dependancies ###
#= require angular/angular

### Clio Components ###
#= require themis_components/index

### Application ###
#= require_self

#= require_tree ./controllers

modules = [
    'ThemisComponents'
]

angular.module 'ThemisComponentsApp', modules
