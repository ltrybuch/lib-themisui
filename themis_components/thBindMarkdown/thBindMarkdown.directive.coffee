angular = require 'angular'
markdown = require 'markdown'

angular.module('ThemisComponents')
    .directive "thBindMarkdown", ->
        restrict: "A"
        link: ($scope, element, attributes) ->
            $scope.$watch attributes.thBindMarkdown, (newMarkdownText) ->
                element.html markdown.parse newMarkdownText if newMarkdownText?
