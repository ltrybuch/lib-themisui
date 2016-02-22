moment = require("moment")

fdescribe 'ThemisComponents: Directive: thDatePicker', ->
  element = scope = compile = validTemplate = null
  testDate = moment("2014-02-16")
  # todayDate = moment()
  # noDate = ""

  beforeEach ->
    scopeAdditions = {date: testDate}
    validTemplate = """
      <th-date-picker ng-model="date"></th-date-picker>
    """
    {element, scope} = compileDirective validTemplate, scopeAdditions

  fit "has a name", ->
    # debugger
    expect(element.find("input.th-input").val()).toBe testDate.format('YYYY-MM-DD')

  # it "creates a default date of today if no date is defined", ->
  #   expect(element.find("input.th-input").val()).toBe todayDate

  # it "parses a valid string into a date according to a default format", ->
  #   expect(element.find("input").val()).toEqual scope.date

  # it "parses a valid date into three formats", ->
  #   scopeAdditions.dateFormat = 'YYYY-MM-DD'

  #   validTemplate = """
  #       <th-date-picker ng-model="date" date-format="dateFormat"></th-date-picker>
  #     """

  # xit "parses the text input into a valid date onBlur", ->
