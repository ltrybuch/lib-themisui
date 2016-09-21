moment = require "moment"
uuid = require "uuid"

angular.module("ThemisComponents")
  .directive "thDatePicker", ->
    restrict: "E"
    template: require "./thDatePicker.template.html"
    scope:
      ngModel: "="
      dateFormat: "@"
      ngChange: "&"
      condensed: "=?"
    bindToController: true
    controllerAs: "datepicker"
    controller: (PopoverManager, $element, $scope) ->
      tabEventCode = 9

      # Use random names, since there might be multiple date pickers in the document.
      @targetName = "datepicker-target-#{uuid.v1()}"
      @contentName = "datepicker-content-#{uuid.v1()}"

      @showPopover = =>
        PopoverManager.showPopover(
          targetName: @targetName
          contentCallback: => PopoverManager.getContent @contentName
        )

      @hidePopover = =>
        PopoverManager.hidePopover @targetName

      # Initialize the model if it isn't a valid moment.
      @ngModel = null unless @ngModel?.isValid?()

      setDateFormat = =>
        validDateFormats = ["YYYY-MM-DD", "MM/DD/YYYY", "DD/MM/YYYY"]
        defaultDateFormat = validDateFormats[0]
        if @dateFormat in validDateFormats then @dateFormat else defaultDateFormat

      @dateFormat = setDateFormat()

      setInputFieldString = =>
        @inputFieldString = @ngModel?.format(@dateFormat) || ""

      # Initialize the input field string.
      setInputFieldString()

      # When the datepicker changes the model, update the input field string.
      @registerModelWatcher = =>
        @unregisterModelWatcher() if @unregisterModelWatcher?
        @unregisterModelWatcher = $scope.$watch "datepicker.ngModel", =>
          setInputFieldString()
          @ngChange?()

      # Update the model and datepicker, unless the user enters an invalid date.
      $scope.$watch "datepicker.inputFieldString", =>
        if @inputFieldString == ""
          @ngModel = null
        else
          parsedDate = moment @inputFieldString, @dateFormat
          @ngModel = parsedDate if parsedDate.isValid()

      @registerModelWatcher()

      # Input Field
      dateInputField = $element.find("input")

      # If tab key is pressed...
      dateInputField.on "keydown", (event) =>
        if (event.which == tabEventCode)
          # ... hide popover.
          @hidePopover()

      # On blur of the input field...
      dateInputField.on "blur", => $scope.$apply =>
        # ... listen for datepicker model changes.
        @registerModelWatcher()

      # On focus of the input field, unregister our model listener.
      dateInputField.on "focus", => $scope.$apply =>
        @showPopover()
        @unregisterModelWatcher()

      return
