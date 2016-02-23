moment = require("moment")

describe 'ThemisComponents: Directive: thDatePicker', ->
  element = scope = validTemplate = null
  testDate = moment("2014-02-16")
  todayDate = moment()
  noDate = ''
  defaultDateFormat = 'YYYY-MM-DD'

  setupDatePicker = (date, dateFormat = '') ->
    scopeAdditions = {}
    scopeAdditions.date = date
    scopeAdditions.dateFormat = dateFormat
    validTemplate = """
      <th-date-picker ng-model="date" date-format="dateFormat"></th-date-picker>
    """
    {element, scope} = compileDirective validTemplate, scopeAdditions

  it "creates a default date of today when date is empty string", ->
    setupDatePicker(noDate)
    expect(element.find("input.th-input").val()).toBe todayDate.format(defaultDateFormat)

  it "creates a date out of a test date with a default format #{defaultDateFormat}", ->
    setupDatePicker(testDate)
    expect(element.find("input.th-input").val()).toBe testDate.format(defaultDateFormat)

  dateFormat = [
    'YYYY-MM-DD'
    'MM/DD/YYYY'
    'DD/MM/YYYY'
  ]
  dateFormat.forEach (format) ->
    it "parses a valid date into format (#{format})", ->
      setupDatePicker(testDate, format)
      expect(element.find("input.th-input").val()).toBe testDate.format(format)
