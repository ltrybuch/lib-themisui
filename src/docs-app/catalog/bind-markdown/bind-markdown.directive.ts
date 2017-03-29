import * as angular from "angular";
import { Converter } from "showdown";
import "prismjs";

interface Attributes extends angular.IAttributes {
  docsBindMarkdown: string;
}

function prepareCodeBlocks(html: string) {
  const wrapperEl = angular.element("<div></div>").html(html);
  angular.forEach(wrapperEl.find("code"), function(codeEl) {
    if (codeEl.className === "") {
      return codeEl.parentElement.className = "language-clike";
    }
  });
  return wrapperEl.html();
};

const converter = new Converter();
converter.setFlavor("github");
converter.setOption("simpleLineBreaks", "");

const DocsBindMarkDownDirective = function(): angular.IDirective {
  return {
    restrict: "A",
    link: function($scope: angular.IScope, element: angular.IAugmentedJQuery, attributes: Attributes) {
      $scope.$watch(attributes.docsBindMarkdown, function(newMarkdownText: string) {
        if (!newMarkdownText) {
          return;
        }

        let markdownHtml = converter.makeHtml(newMarkdownText);
        markdownHtml = prepareCodeBlocks(markdownHtml);
        element.html(markdownHtml);
        Prism.highlightAll(false);
      });
    },
  };
};

export default DocsBindMarkDownDirective;
