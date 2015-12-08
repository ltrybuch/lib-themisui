angular = require 'angular'
marked = require 'marked'
Prism = window.Prism

prismHelper =
  # Retrieve Prism grammar object for a given language string
  grammar: (language) ->
    languages =
      html: "markup"

    prismLanguage = languages[language]

    Prism.languages[prismLanguage || "clike"]
  # Ensure wrapping <pre> has correct class for Prism styling
  prepareCodeBlocks: (html) ->
    wrapperEl = angular.element("<div></div>").html(html)

    angular.forEach wrapperEl.find("code"), (codeEl) ->
      if codeEl.className == ""
        codeEl.parentElement.className = "language-clike"
      else
        codeEl.parentElement.className = codeEl.className.replace(/lang-/, "language-")

    wrapperEl.html()


marked.setOptions
  highlight: (code, language) ->
    Prism.highlight(code, prismHelper.grammar(language))

angular.module('ThemisComponents')
  .directive "thBindMarkdown", ->
    restrict: "A"
    link: ($scope, element, attributes) ->
      $scope.$watch attributes.thBindMarkdown, (newMarkdownText) ->
        return unless newMarkdownText?

        markdownHtml = marked(newMarkdownText)
        markdownHtml = prismHelper.prepareCodeBlocks(markdownHtml)
        element.html(markdownHtml)
        Prism.highlightAll()
