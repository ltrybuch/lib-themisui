context = describe
describe 'ThemisComponents: Service: thAlertManager', ->
  AlertManager = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

    inject (_AlertManager_) ->
      AlertManager = _AlertManager_

  it 'should exist', ->
    expect(AlertManager?).toBe true

  describe '#showSuccess()', ->
    it 'should populate the alertMessage object', ->
      AlertManager.showSuccess "Risus Lorem"
      expect(AlertManager.alertMessage).toEqual {message: 'Risus Lorem', type: 'success'}

  describe '#showError()', ->
    it 'should populate the alertMessage object', ->
      AlertManager.showError "Sit Ipsum"
      expect(AlertManager.alertMessage).toEqual {message: 'Sit Ipsum', type: 'error'}

  describe '#showWarning()', ->
    it 'should populate the alertMessage object', ->
      AlertManager.showWarning "Vestibulum Ullamcorper"
      expect(AlertManager.alertMessage).toEqual {message: 'Vestibulum Ullamcorper', type: 'warning'}

  describe '#hideAlert()', ->
    it 'should clear the alertMessage object', ->
      AlertManager.hideAlert
      expect(AlertManager.alertMessage).toEqual
