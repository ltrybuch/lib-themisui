angular.module("ThemisComponentsApp")
  .directive "docsComponentExample", ->
    restrict: "E"
    scope:
      componentName: "<componentName"
      example: "<componentExample"
      whitelistLocal: "<componentWhitelistLocal"
      exampleIndex: "<"
    template: require "./component-example.template.html"
    controller: ($scope, $element, $timeout, $location) ->
      example = $scope.example
      externalFilePathRegex = /("|')\/(components.+)("|')/g
      moduleRegex = /angular.module\(("|')(.+)("|')\)/ #angular.module("thTabsetDemo")
      prependHost = (match, $1, $2, $3) -> $1 + includeBase + $2 + $3
      includeBase = $location.protocol() + "://" + $location.host() \
          + (if $location.port()? then ":" + $location.port()) + "/"
      includeJS  = [
        "#{includeBase}node_modules/jquery/dist/jquery.js"
        "#{includeBase}assets/docs-vendor.js",
        "#{includeBase}assets/examples.js"
      ]
      includeCSS = [
        "#{includeBase}assets/examples.css",
        "#{includeBase}assets/lib-themisui-styles.css"
        "//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
      ]
      configBlock = """
        .config(($sceDelegateProvider) ->
          $sceDelegateProvider.resourceUrlWhitelist [
            "self"
            "#{includeBase}**"
          ]
        )
      """
      penExampleCoffee = example.coffee
        .replace moduleRegex, (match) -> match + if $scope.whitelistLocal then configBlock else ""
        .replace externalFilePathRegex, prependHost
      penExampleHtml = example.html.replace externalFilePathRegex, prependHost

      exampleInitialized = no
      initializeExample = ->
        exampleInitialized = yes
        $scope.mode = ""

        exampleFrame = $element.find("iframe")[0]
        if exampleFrame?
          html = example.html

          styles = for styleSrc in includeCSS
            "<link href=\"#{styleSrc}\" rel=\"stylesheet\" type=\"text/css\">"
          html = html.replace "</body>", "#{styles.join("")}</body>"

          js = includeJS[..]
          # js.push "#{includeBase}/components/#{$scope.componentName}/examples/#{example.name}.js"
          scripts = for scriptSrc in js
            "<script src=\"#{scriptSrc}\"></script>"
          html = html.replace "</body>", "#{scripts.join("")}</body>"

          exampleFrame.contentWindow.document.open()
          exampleFrame.contentWindow.document.write html
          exampleFrame.contentWindow.document.close()
          observer = new MutationObserver (mutations) ->
            # Just accessing scrollTop seems to fix a weird FF flicker error.
            # Once FF supports `scrollingElement` we can take out our polyfill.
            # CLIO-37920
            mutations[0].target.ownerDocument.scrollingElement
              .querySelector(".component-details-view").scrollTop

            $timeout ->
              if exampleFrame.contentWindow isnt null
                scrollingElement = exampleFrame
                                    .ownerDocument
                                    .scrollingElement
                                    .querySelector ".component-details-view"
                scroll = scrollingElement.scrollTop
                exampleFrame.style.height = "0px"
                exampleFrame.style.height = exampleFrame
                                              .contentWindow
                                              .document
                                              .body
                                              .scrollHeight + 10 + "px"
                scrollingElement.scrollTop = scroll
            , 1500

          config = {childList: true, attributes: true, characterData: true}

          observer.observe exampleFrame, config

          exampleFrame.style.height = "0px"
          $timeout ->
            $scope.mode = "example"
            exampleFrame.style.height = exampleFrame
                                          .contentWindow
                                          .document
                                          .body
                                          .scrollHeight + 10 + "px"
          , 1500

          $timeout -> Prism.highlightAll()

      $scope.getLanguage = (fileName) ->
        extension = fileName.match(/\.([a-zA-Z]+$)/)[1]
        if extension is "html"
          return "language-markup"
        else if extension is "coffee"
          return "language-coffeescript"
        else if extension is "json"
          return "language-json"

      $scope.penData = JSON.stringify
        title: "#{$scope.componentName} - #{example.name}"
        html: penExampleHtml
        js: penExampleCoffee
        js_pre_processor: "coffeescript"
        js_external: includeJS.join ";"
        css_external: includeCSS.join ";"

      $scope.showTab = (name) ->
        $scope.mode = name

        if name is "example" and not exampleInitialized
          initializeExample()

      $scope.showTab "example"
