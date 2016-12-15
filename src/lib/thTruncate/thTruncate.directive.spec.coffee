{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'ThemisComponents: Directive: thTruncate', ->
  element = directive = ctrl = null
  beforeEach angular.mock.module 'ThemisComponents'

  beforeEach ->
    directive =
      compileDirective('<th-truncate text="Nulla vitae elit libero, a pharetra
      augue. Maecenas sed diam eget risus varius blandit sit amet non magna.
      Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec nulla
      nonmetus auctor fringilla."></th-truncate>')
    element = directive.element
    ctrl = directive.scope.$$childHead.truncate

  it 'the expanded state is toggled on click', ->
    closedText = element.text().replace(/\s\s+/g, '').replace('...(more)', '')
    expect(closedText.length).toBe 100

    expect(ctrl.expanded).toBe false
    element.find('.truncate-control').triggerHandler 'click'
    expect(ctrl.expanded).toBe true

    openText = element.text().replace(/\s\s+/g, '').replace('(close)', '')
    expect(openText.length).toBe 206

  context 'when the string length limit is manually set', ->
    beforeEach ->
      directive =
        compileDirective('<th-truncate text="Lorem" limit="2"></th-truncate>')
      element = directive.element
      ctrl = directive.scope.$$childHead.truncate

    it 'should apply to the element and show the truncate control', ->
      expect(ctrl.limit).toBe 2
      expect(element.find('.truncate-control').length).toBe 1

  context 'when the string length is shorter than the limit', ->
    beforeEach ->
      directive = compileDirective('<th-truncate text="Lorem"></th-truncate>')
      element = directive.element

    it 'does not display the truncate control', ->
      expect(element.find('.truncate-control').length).toBe 0
