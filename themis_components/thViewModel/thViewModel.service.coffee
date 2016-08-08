angular.module 'ThemisComponents'
  .factory 'ViewModel', -> ViewModel

ViewModel = (model, schema = {}) ->
  vm = {model: model, view: {}}
  Object.apply vm.view, schema
  return vm
