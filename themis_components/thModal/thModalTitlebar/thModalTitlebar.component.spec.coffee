foo = """
  <th-modal-titlebar title="Foo"></th-modal-titlebar>
"""

templates =
  simple: """
      <th-modal-titlebar title="Foo"></th-modal-titlebar>
    """
  sansCloseButton: """
      <th-modal-titlebar title="Foo" show-close-button="false"></th-modal-titlebar>
    """
  destroyType: """
      <th-modal-titlebar title="Foo" type="destroy"></th-modal-titlebar>
    """

createModalTitlebarController = ->
  $rootScope = $componentController = null
  inject (_$rootScope_, _$componentController_) ->
    $rootScope = _$rootScope_
    $componentController = _$componentController_

  scope = $rootScope.$new().$new()
  scope.$parent.modal =
    dismiss: -> return

  element = angular.element templates.simple

  controller = $componentController "thModalTitlebar",
    $scope: scope
    $element: element

  return {controller, scope, element}

createTitlebarElement = (template = templates.simple) ->
  $rootScope = $compile = null
  inject (_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_

  scope = $rootScope.$new()
  element = angular.element "<div>#{template}</div>"
  element = $compile(element)(scope)
  element = element.find("th-modal-titlebar")
  scope.$apply()

  return {element, scope}

describe "ThemisComponents: Component: thModalTitlebar", ->
  beforeEach angular.mock.module "ThemisComponents"

  it "should dismiss the modal when close is called", ->
    {controller, scope} = createModalTitlebarController()

    spyOn scope.$parent.modal, 'dismiss'

    controller.close()
    expect(scope.$parent.modal.dismiss).toHaveBeenCalled()

  it "should have a close button by default", ->
    {element} = createTitlebarElement()
    expect(element.find("div").text().trim()).toBe "Foo"

  it "should have a close button by default", ->
    {element} = createTitlebarElement()
    expect(element.find("button").length).toBe 1

  it "should be of type standard by default", ->
    {element} = createTitlebarElement()
    expect(element.hasClass "type-standard").toBe true

  it "should allow for close button to be hidden", ->
    {element} = createTitlebarElement(templates.sansCloseButton)
    expect(element.find("button").length).toBe 0

  it "should allow for type to be set to destroy", ->
    {element} = createTitlebarElement(templates.destroyType)
    expect(element.hasClass "type-destroy").toBe true
