import * as angular from "angular";
import { CatalogService } from "./catalog/catalog.service";
import { StateProvider, UrlRouterProvider, Transition } from "angular-ui-router";

angular.module("ThemisComponentsApp")
  .config(function(
    $stateProvider: StateProvider,
    $urlRouterProvider: UrlRouterProvider,
    $locationProvider: angular.ILocationProvider
  ) {
    $locationProvider.html5Mode(true);

    $stateProvider
      .state({
        name: "index",
        url: "/",
        component: "docsComponentDetails"
      })

      .state({
        name: "component",
        url: "/component/:name",
        component: "docsComponentDetails",
        resolve: {
          component: function(catalogService: CatalogService, $transition$: Transition) {
            return catalogService.getComponent($transition$.params().name);
          }
        }
      })

      .state({
        name: "doc",
        url: "/doc/:name",
        templateProvider: function(catalogService: CatalogService, $transition$: Transition) {
          const route = $transition$.params().name;
          const doc = catalogService.getDoc(route) || catalogService.getGlobalDoc(route);
          const name = doc && catalogService.parseComponentName(doc.name);

          if (doc && doc.isMarkdownDoc) {
            return `<docs-text-documentation doc="'${route}'"></docs-text-documentation>`;
          } else if (name) {
            return `<${name}></${name}>`;
          } else {
            console.warn(`Selected route "${route}" not found.`);
            return "";
          }
        }
      });

    $urlRouterProvider.otherwise("/");
  });
