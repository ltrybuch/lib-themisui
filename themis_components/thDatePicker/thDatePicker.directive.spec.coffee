moment = require "moment"

describe 'ThemisComponents: Directive: thDatePicker', ->
  element = scope = validTemplate = null
  todayDate = moment()
  noDate = ''
  defaultDateFormat = 'YYYY-MM-DD'

  setupDatePicker = (date, dateFormat = '') ->
    scopeAdditions = {date: date, dateFormat: dateFormat}
    validTemplate = """
      <th-date-picker ng-model="date" date-format="{{dateFormat}}"></th-date-picker>
    """
    {element} = compileDirective validTemplate, scopeAdditions

  it "creates a date out of a test date with a default format #{defaultDateFormat}", ->
    setupDatePicker(todayDate)
    expect(element.find("input.th-input").val()).toBe todayDate.format(defaultDateFormat)

  # test the 3 valid date formats
  dateFormat = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']
  
  dateFormat.forEach (format) ->
    it "parses a valid date into format (#{format})", ->
      setupDatePicker(todayDate, format)
      expect(element.find("input.th-input").val()).toBe todayDate.format(format)
