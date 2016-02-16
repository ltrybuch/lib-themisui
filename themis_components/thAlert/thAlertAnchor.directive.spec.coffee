context = describe
describe "ThemisComponents: Directive: thAlertAnchor", ->
  directive = ctrl = scope = element = AlertManager = $sce = null

  beforeEach inject (_AlertManager_, _$sce_) ->
    AlertManager = _AlertManager_
    $sce = _$sce_
    element = """<th-alert-anchor></th-alert-anchor>"""
    {scope} = compileDirective(element)

  describe "load message data", ->
    it 'should load the success data', ->
      AlertManager.showSuccess "Risus Lorem"
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Risus Lorem'
      expect(AlertManager.alertMessage.type).toEqual 'success'

    it 'should load the error data', ->
      AlertManager.showError "Sit Ipsum"
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Sit Ipsum'
      expect(AlertManager.alertMessage.type).toEqual 'error'

    it 'should load the warning data', ->
      AlertManager.showWarning "Quam Tellus"
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Quam Tellus'
      expect(AlertManager.alertMessage.type).toEqual 'warning'

  describe "dismiss", ->
    it 'clears the message', ->
      AlertManager.showSuccess "Risus Lorem", "success"
      scope.alertAnchor.dismiss()
      expect(scope.alertAnchor.alertMessage).toEqual
        message: ''
        type: ''
