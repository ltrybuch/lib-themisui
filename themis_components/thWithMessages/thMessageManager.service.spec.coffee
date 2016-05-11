{
  createDOMElement
} = require "spec_helpers"
context = describe

normalizeText = (text) ->
  text.trim().replace /\s+/g, ' '

describe 'thMessageManager.service', ->
  attributes = extended = messages = null
  messageNode = MessageService = options = null

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach ->
    inject (_MessageService_) -> MessageService = _MessageService_

    messages =
      minlength: "custom minLength message"
      maxlength: "custom maxLength message"
      min: "custom min message"
      max: "custom max message"
    attributes =
      ngMaxlength: 25
      ngMinlength: 25
      min: 10
      max: 20

  it "should exist", ->
    expect(MessageService?).toBe true

  describe "#extendMessages()", ->
    beforeEach ->
      extended = MessageService.extendMessages(messages, attributes)

    it "completes missing validation types", ->
      expect(Object.keys(extended).length).toBe 7
      expect(extended["required"]?).toBe true
      expect(extended["pattern"]?).toBe true

    it "doesn't override custom messages", ->
      expect(extended["minlength"]).toEqual "custom minLength message"
      expect(extended["maxlength"]).toEqual "custom maxLength message"
      expect(extended["min"]).toEqual "custom min message"
      expect(extended["max"]).toEqual "custom max message"
      expect(Object.keys(extended).length).toBe 7

    context "without custom messages", ->
      beforeEach ->
        extended = MessageService.extendMessages({}, attributes)

      it "returns back all our default messages", ->
        expect(Object.keys(extended).length).toBe 7
        expect(extended["minlength"]).toEqual "Please enter at least 25 characters."
        expect(extended["maxlength"]).toEqual "Please enter no more than 25 characters."
        expect(extended["required"]).toEqual "This field is required."
        expect(extended["pattern"]).toEqual "Invalid Response."

      context "with both min and max attrs set", ->
        it "returns a range message", ->
          expect(extended["min"]).toEqual "Please enter a number between 10 and 20."
          expect(extended["max"]).toEqual "Please enter a number between 10 and 20."

  describe "#generateNgMessagesElement()", ->
    beforeEach ->
      messages =
        minlength: "custom minlength"
        maxlength: "custom maxlength"
        required: "custom required"
        pattern: "custom pattern"
        min: "custom min"
        max: "custom max"
        number: "custom number"
      options = {messages, formName: "form", modelName: "model", isInlineEl: false}

    context "with block element", ->
      beforeEach ->
        templateString = MessageService.generateNgMessagesElement(options)
        messageNode = $(createDOMElement templateString)

      it "returns template with the $submitted, $invalid, $touched checks", ->
        returnedAttr = messageNode.find(".message-container").attr("ng-if")
        returnedText = normalizeText returnedAttr
        expectedText = "form.model.$invalid && (form.model.$touched || form.$submitted)"
        expect(returnedText).toEqual expectedText

      it "adds the custom messages for each validation type", ->
        minlength = messageNode.find("[ng-message|='minlength']").text()
        expect(normalizeText(minlength)).toEqual "custom minlength"

        maxlength = messageNode.find("[ng-message|='maxlength']").text()
        expect(normalizeText(maxlength)).toEqual "custom maxlength"

        required = messageNode.find("[ng-message|='required']").text()
        expect(normalizeText(required)).toEqual "custom required"

        pattern = messageNode.find("[ng-message|='pattern']").text()
        expect(normalizeText(pattern)).toEqual "custom pattern"

        min = messageNode.find("[ng-message|='min']").text()
        expect(normalizeText(min)).toEqual "custom min"

        max = messageNode.find("[ng-message|='max']").text()
        expect(normalizeText(max)).toEqual "custom max"

        number = messageNode.find("[ng-message|='number']").text()
        expect(normalizeText(number)).toEqual "custom number"

    context "with inline element", ->
      beforeEach ->
        options.isInlineEl = true
        templateString = MessageService.generateNgMessagesElement(options)
        messageNode = $(createDOMElement templateString)

      it "returns template with $submitted, and $invalid checks", ->
        returnedAttr = messageNode.find(".message-container").attr("ng-if")
        returnedText = normalizeText returnedAttr
        expectedText = "form.$submitted && form.model.$invalid"
        expect(returnedText).toEqual expectedText

    context "with default messages", ->
      beforeEach ->
        options.messages = MessageService.extendMessages({}, {})
        templateString = MessageService.generateNgMessagesElement(options)
        messageNode = $(createDOMElement templateString)

      it "sets default text for each validation type", ->
        minlength = messageNode.find("[ng-message|='minlength']").text()
        expect(normalizeText(minlength)).toEqual "Please enter at least characters."

        maxlength = messageNode.find("[ng-message|='maxlength']").text()
        expect(normalizeText(maxlength)).toEqual "Please enter no more than characters."

        required = messageNode.find("[ng-message|='required']").text()
        expect(normalizeText(required)).toEqual "This field is required."

        pattern = messageNode.find("[ng-message|='pattern']").text()
        expect(normalizeText(pattern)).toEqual "Invalid Response."

        min = messageNode.find("[ng-message|='min']").text()
        expect(normalizeText(min)).toEqual "Please enter a valid number equal to or greater than 0."

        max = messageNode.find("[ng-message|='max']").text()
        expect(normalizeText(max)).toEqual "Please enter a valid number less than or equal to 0."
