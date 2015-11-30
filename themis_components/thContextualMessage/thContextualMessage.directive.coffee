angular.module('ThemisComponents')
  .directive "thContextualMessageAnchor", (ContextualMessageManager, $document, $timeout) ->
    restrict: "A"
    scope: {}
    link: ($scope, element, attributes) ->
      messageContext = attributes.thContextualMessageAnchor
      $scope.messages = ContextualMessageManager.messagesForContext messageContext

      $scope.$watch "messages.length", (messageCount) ->
        for elm in document.querySelectorAll ".thContextualMessage.context-#{messageContext}"
          angular.element(elm).remove()

          if messageCount > 0
            anchorRect = element[0].getBoundingClientRect()
            messageElement = angular.element """
              <div>
                #{$scope.messages[0].text}
              </div>
            """
            messageElement.addClass "thContextualMessage"
            messageElement.addClass "context-#{messageContext}"
            $document.find('body').append messageElement
            messageElement.css
              top: "#{ anchorRect.top + anchorRect.height }px"
              left: "#{ anchorRect.left + anchorRect.width/2 - messageElement[0].clientWidth/2 }px"

            ContextualMessageManager.showedMessageForContext messageContext
