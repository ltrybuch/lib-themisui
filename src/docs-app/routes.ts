import * as angular from "angular";
import { CatalogService } from "./catalog/catalog.service";
import { StateProvider, UrlRouterProvider, Transition } from "angular-ui-router";

angular.module("ThemisComponentsApp")
  .config(function(
    $stateProvider: StateProvider,
    $urlRouterProvider: UrlRouterProvider,
    $locationProvider: angular.ILocationProvider,
  ) {
    $locationProvider.html5Mode(true);

    $stateProvider
      .state({
        name: "index",
        url: "/",
        component: "docsComponentDetails",
      })

      .state({
        name: "component",
        url: "/component/:slug",
        component: "docsComponentDetails",
        resolve: {
          component: function(catalogService: CatalogService, $transition$: Transition) {
            return catalogService.getComponent($transition$.params().slug);
          },
        },
      })

      .state({
        name: "doc",
        url: "/doc/:section/:slug",
        templateProvider: function(catalogService: CatalogService, $transition$: Transition) {
          const section = $transition$.params().section;
          const routeSlug = $transition$.params().slug;
          const doc = section === "global"
            ? catalogService.getGlobalDocByUrlSlug(routeSlug)
            : catalogService.getDocByUrlSlug(routeSlug);
          const name = doc && catalogService.parseComponentName(doc.name);

          if (doc && doc.isMarkdownDoc) {
            return `<docs-text-documentation slug="'${routeSlug}'"></docs-text-documentation>`;
          } else if (name) {
            return `<${name}></${name}>`;
          } else {
            console.warn(`Selected routeSlug "${routeSlug}" not found.`);
            return "";
          }
        },
      });

    $urlRouterProvider.otherwise("/");
  });
