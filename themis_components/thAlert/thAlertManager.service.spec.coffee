context = describe
describe 'ThemisComponents: Service: thAlertManager', ->
  AlertManager = $sce = $timeout = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

    inject (_AlertManager_, _$sce_, _$timeout_) ->
      AlertManager = _AlertManager_
      $sce = _$sce_
      $timeout = _$timeout_

  it 'should exist', ->
    expect(AlertManager?).toBe true

  describe '#showSuccess()', ->
    it 'should call showAlert and populate the alertMessage object', ->
      AlertManager.showSuccess "Risus Lorem"
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Risus Lorem'
      expect(AlertManager.alertMessage.type).toEqual 'success'

  describe '#showError()', ->
    it 'should call showAlert and populate the alertMessage object', ->
      AlertManager.showError "Sit Ipsum"
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Sit Ipsum'
      expect(AlertManager.alertMessage.type).toEqual 'error'

  describe '#showWarning()', ->
    it 'should call showAlert and populate the alertMessage object', ->
      AlertManager.showWarning "Vestibulum Sit"
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Vestibulum Sit'
      expect(AlertManager.alertMessage.type).toEqual 'warning'

  describe '#showAlert()', ->
    it 'should populate the alertMessage object', ->
      AlertManager.showAlert 'Lorem Ornare'
      expect($sce.getTrustedHtml(AlertManager.alertMessage.message)).toEqual 'Lorem Ornare'

  describe '#hideAlert()', ->
    it 'should clear the alertMessage object', ->
      AlertManager.hideAlert
      expect(AlertManager.alertMessage).toEqual {}

  describe '#timeout()', ->
    it 'should hide the alert after the timer runs out', ->
      AlertManager.timeout
      $timeout.flush(3000)
      expect(AlertManager.hideAlert).toHaveBeenCalled
