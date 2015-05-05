class PopoverManagerMock
  templateFromURL: jasmine.createSpy('templateFromURL').and.callFake ->
    angular.injector(['ng']).invoke ($q) ->
      $q (resolve) -> resolve "<h1>Popover</h1>"
