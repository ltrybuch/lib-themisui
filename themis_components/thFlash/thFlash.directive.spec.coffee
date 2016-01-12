context = describe
describe "ThemisComponents: Directive: thFlash", ->
  directive = ctrl = scope = element = FlashManager = null

  beforeEach inject ($compile, $rootScope, _FlashManager_) ->
    FlashManager = _FlashManager_
    element = """<th-flash></th-flash>"""
    ctrl = compileDirective(element)

  describe "load message data", ->
    it 'should load the success data', ->
      FlashManager.showFlash "Risus Lorem", "success"
      expect(ctrl.scope.flash.flashMessage).toEqual {message: 'Risus Lorem', type: 'success'}

    it 'should load the error data', ->
      FlashManager.showFlash "Sit Ipsum", "error"
      expect(ctrl.scope.flash.flashMessage).toEqual {message: 'Sit Ipsum', type: 'error'}

  describe "dismiss", ->
    it 'clears the message', ->
      FlashManager.showFlash "Risus Lorem", "success"
      ctrl.scope.flash.dismiss()
      expect(ctrl.scope.flash.flashMessage).toEqual {message: '', type: ''}
