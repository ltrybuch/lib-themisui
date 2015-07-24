angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', (ModalManager) ->

    @templateSrc1 = 'exampleTemplates/thModalExampleTemplate1.html'
    @modalName1 = "firstTemplateUrl"

    @templateSrc2 = 'exampleTemplates/thModalExampleTemplate2.html'
    @modalName2 = "secondTemplateUrl"

    @displayModal = (name) ->
      ModalManager.showModal(name)
    return
