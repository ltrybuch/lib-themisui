{
  compileDirective
} = require "spec_helpers"
moment = require "moment"

xdescribe 'ThemisComponents: Directive: thDatePicker', ->
  element = validTemplate = null
  todayDate = moment()
  defaultDateFormat = 'YYYY-MM-DD'


  it "creates a date out of a test date with a default format #{defaultDateFormat}", ->
    scopeAdditions = {date: todayDate}
    template = """
      <th-date-picker ng-model="date"></th-date-picker>
      """
    {element} = compileDirective(template, scopeAdditions)
    expect(element.find("input.th-input").val()).toBe todayDate.format defaultDateFormat

  # test the 3 valid date formats
  dateFormat = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']

  dateFormat.forEach (format) ->
    it "parses a valid date into format (#{format})", ->
      scopeAdditions = {date: todayDate, dateFormat: format}
      template = """
        <th-date-picker ng-model="date" date-format="{{dateFormat}}"></th-date-picker>
        """
      {element} = compileDirective(template, scopeAdditions)

      expect(element.find("input.th-input").val()).toBe todayDate.format format
