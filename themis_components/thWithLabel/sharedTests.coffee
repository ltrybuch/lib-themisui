element = null

module.exports =
  testingInlineLabel: (compileElementFn) ->
    beforeEach ->
      {element} = compileElementFn()

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "label name"

  testingNgChange: (compileElementFn) ->
    beforeEach ->
      spyOn window, 'alert'
      {element} = compileElementFn()

      trigger = if element.hasClass "th-radio-group"
        element.children().last()
      else
        element.parent()

      trigger.triggerHandler 'click'

    it "triggers an alert", ->
      expect(window.alert).toHaveBeenCalledWith 'Alerting!'

    it "triggers an alert only once", ->
      expect(window.alert.calls.count()).toEqual 1

  testingPrependedLabel: (compileElementFn) ->
    beforeEach ->
      {element} = compileElementFn()

    it "adds inner div element with class 'label-text' above input element", ->
      expect(element.prev().is("div.label-text")).toBe true

    it "adds 'with-label' value to div.label-text text", ->
      expect(element.prev().text()).toMatch "label name"

    it "wraps input in a label element", ->
      expect(element.parent().hasClass("th-label")).toBe true
      expect(element.parent().is("label")).toBe true
