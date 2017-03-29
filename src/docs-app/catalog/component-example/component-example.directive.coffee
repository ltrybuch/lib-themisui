debounce = require "debounce"

angular.module("ThemisComponentsApp")
  .directive "docsComponentExample", ->
    restrict: "E"
    scope:
      componentName: "<componentName"
      example: "<componentExample"
      whitelistLocal: "<componentWhitelistLocal"
      exampleIndex: "<"
    template: require "./component-example.template.html"
    controller: ($scope, $element, $timeout, $location, $window) ->
      scrollContainerSelector = ".component-details-view"
      penExampleTypescript = penExampleCoffee = penExampleHtml = null
      example = $scope.example
      externalFilePathRegex = /("|')\/(components.+)("|')/g
      moduleRegex = /angular.module\(("|')(.+)("|')\)/
      prependHost = (match, $1, $2, $3) -> $1 + includeBase + $2 + $3
      includeBase = $location.protocol() + "://" + $location.host() \
        + (if $location.port() isnt 80 then ":" + $location.port() else "") + "/"

      includeJS  = [
        "#{includeBase}node_modules/jquery/dist/jquery.js"
        "#{includeBase}assets/docs-vendor.js",
        "#{includeBase}assets/examples.js"
      ]

      includeCSS = [
        "//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
      ]

      configBlockCS = """
        .config(($sceDelegateProvider) ->
          $sceDelegateProvider.resourceUrlWhitelist [
            "self"
            "#{includeBase}**"
          ]
        )
      """

      configBlockTS = """
        .config(function($sceDelegateProvider) {
          $sceDelegateProvider.resourceUrlWhitelist([
            "self",
            "#{includeBase}**"
          ]);
        })
      """

      if example.typescript
        penExampleTypescript = example.typescript
          .replace externalFilePathRegex, prependHost
          .replace moduleRegex, (match) ->
            match + if $scope.whitelistLocal then configBlockTS else ""

      else if example.coffee
        penExampleCoffee = example.coffee
          .replace externalFilePathRegex, prependHost
          .replace moduleRegex, (match) ->
            match + if $scope.whitelistLocal then configBlockCS else ""

      penExampleHtml = example.html.replace externalFilePathRegex, prependHost

      $scope.exampleInitialized = no

      initializeExample = ->
        $scope.exampleInitialized = yes
        $scope.mode = ""

        exampleFrame = $element.find("iframe")[0]
        if exampleFrame?
          html = example.html

          styles = for styleSrc in includeCSS
            "<link href=\"#{styleSrc}\" rel=\"stylesheet\" type=\"text/css\">"
          html = html.replace "</body>", "#{styles.join("")}</body>"

          js = includeJS[..]
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
              .querySelector(scrollContainerSelector).scrollTop

            $timeout ->
              if exampleFrame.contentWindow isnt null
                scrollingElement = exampleFrame
                  .ownerDocument.scrollingElement.querySelector scrollContainerSelector
                scroll = scrollingElement.scrollTop
                exampleFrame.style.height = "0px"
                exampleFrame.style.height = exampleFrame
                  .contentWindow?.document.body.scrollHeight + 10 + "px"
                scrollingElement.scrollTop = scroll
            , 1500

          config = {childList: true, attributes: true, characterData: true}

          observer.observe exampleFrame, config

          exampleFrame.style.height = "0px"
          $timeout ->
            $scope.mode = "example"
            exampleFrame.style.height = exampleFrame
              .contentWindow?.document.body.scrollHeight + 10 + "px"
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
        else if extension is "ts"
          return "language-typescript"

      $scope.penData = JSON.stringify
        title: "#{$scope.componentName} - #{example.name}"
        html: penExampleHtml
        js: penExampleTypescript or penExampleCoffee
        js_pre_processor: if penExampleTypescript then "typescript" else "coffeescript"
        js_external: includeJS.join ";"
        css_external: includeCSS.join ";"

      $scope.showTab = (name) ->
        $scope.mode = name

        if name is "example" and not $scope.exampleInitialized
          initializeExample()

      eventSuffix = $scope.componentName + $scope.exampleIndex

      scrollHandler = debounce ->
        if $scope.exampleInitialized
          $(scrollContainerSelector).off "scroll.#{eventSuffix}", scrollHandler
          return

        if $element[0].getBoundingClientRect().top < $window.innerHeight + 100
          $scope.showTab "example"
      , 100

      @$onDestroy = ->
        $(scrollContainerSelector).off "scroll.#{eventSuffix}", scrollHandler

      @$postLink = ->
        $(scrollContainerSelector).on "scroll.#{eventSuffix}", scrollHandler
        scrollHandler()

      return
