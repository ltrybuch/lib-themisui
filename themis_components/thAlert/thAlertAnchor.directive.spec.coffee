context = describe
describe "ThemisComponents: Directive: thAlertAnchor", ->
  directive = ctrl = scope = element = AlertManager = null

  beforeEach inject ($compile, $rootScope, _AlertManager_) ->
    AlertManager = _AlertManager_
    element = """<th-alert-anchor></th-alert-anchor>"""
    {scope} = compileDirective(element)

  describe "load message data", ->
    it 'should load the success data', ->
      AlertManager.showSuccess "Risus Lorem"
      expect(scope.alertAnchor.alertMessage).toEqual {message: 'Risus Lorem', type: 'success'}

    it 'should load the error data', ->
      AlertManager.showError "Sit Ipsum"
      expect(scope.alertAnchor.alertMessage).toEqual {message: 'Sit Ipsum', type: 'error'}

    it 'should load the warning data', ->
      AlertManager.showWarning "Vestibulum Ullamcorper"
      expect(scope.alertAnchor.alertMessage).toEqual {message: 'Vestibulum Ullamcorper', type: 'warning'}

  describe "dismiss", ->
    it 'clears the message', ->
      AlertManager.showSuccess "Risus Lorem", "success"
      scope.alertAnchor.dismiss()
      expect(scope.alertAnchor.alertMessage).toEqual {message: '', type: ''}
