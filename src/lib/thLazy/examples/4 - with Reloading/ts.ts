class DemoController {
  /* @ngInject */
  constructor(private LazyManager: any) {}

  reload() {
    this.LazyManager.reload("example-name");
  }
}

angular.module("thLazyDemo")
  .controller("LazyReloadController", DemoController);
