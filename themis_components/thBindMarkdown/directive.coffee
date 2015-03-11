angular.module('ThemisComponents')
    .directive "thBindMarkdown", ->
        restrict: "A"
        link: ($scope, element, attributes) ->
            $scope.$watch attributes.thBindMarkdown, (newMarkdownText) ->
                element.html markdown.toHTML newMarkdownText if newMarkdownText?
