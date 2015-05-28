describe 'ThemisComponents: Service: PopoverManager', ->
  httpBackend = PopoverManager = null
  mockResponse = "<h1>Popover</h1>"

  beforeEach ->
    module 'ThemisComponents'

  beforeEach inject ($injector) ->
      httpBackend = $injector.get '$httpBackend'
      PopoverManager = $injector.get 'PopoverManager'

  beforeEach ->
    httpBackend.when('GET', '/template.html').respond mockResponse

  it 'should fetch a template', ->
    httpBackend.expectGET '/template.html'

    PopoverManager.templateFromURL '/template.html'
      .then (template) ->
        expect(template).toBe mockResponse

    httpBackend.flush()
