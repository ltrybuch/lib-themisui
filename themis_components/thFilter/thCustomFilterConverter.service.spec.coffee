describe "ThemisComponents: Service: CustomFilterConverter", ->
  CustomFilterConverter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _CustomFilterConverter_) ->
    CustomFilterConverter = _CustomFilterConverter_

  describe "#mapToCustomFilterArray", ->
    it "should throw an error when called on base class", ->
      customFilterConverter = new CustomFilterConverter
      expect(-> customFilterConverter.mapToCustomFilterArray()).toThrow()
