EventEmitter = require 'events'
context = describe

describe 'ThemisComponents: Service: ViewModel', ->
  viewModel = ViewModel = scope = null

  beforeEach angular.mock.module 'ThemisComponents'

  beforeEach inject (_ViewModel_, _$rootScope_) ->
    ViewModel = _ViewModel_
    scope = _$rootScope_

  it "converts a data object to an instance of ViewModel", ->
    model = {name: "Johnny"}
    viewModel = new ViewModel model, {}

    expect(viewModel instanceof ViewModel).toBe true

  it "add property arguments as view properties", ->
    model = {name: "Johnny"}
    viewModel = new ViewModel model,
      {axeMurderer: {default: yes}, location: {default: "Overlook Hotel"}}
    expect(viewModel.view.axeMurderer).toBe true
    expect(viewModel.view.location).toBe "Overlook Hotel"

  context "when no view properties are passed", ->
    it "returns an empty view object", ->
      model = {name: "Johnny"}
      viewModel = new ViewModel model
      expect(viewModel.view).toEqual {}

  it "wrapped incoming data in a model object", ->
    model = {name: "Johnny", quote: "all work and no play…", writer: true}
    viewModel = new ViewModel model
    expect(viewModel.model.name).toEqual "Johnny"
    expect(viewModel.model.quote).toEqual "all work and no play…"
    expect(viewModel.model.writer).toEqual true

    expect(viewModel.name).toEqual undefined

  context "when the event property is included with a view object", ->
    beforeEach ->
      model = {name: "Johnny"}
      viewModel = new ViewModel model, {axeMurderer: default: no, evented: yes}

    it "the viewModel extends EventEmitter", ->
      expect(viewModel instanceof require("events").EventEmitter).toBe true
