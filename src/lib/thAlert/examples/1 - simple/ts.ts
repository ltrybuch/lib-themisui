class DemoCtrl {
  /* @ngInject */
  constructor(private AlertManager: any) {}

  displaySuccess() {
    this.AlertManager.showSuccess("Your message has been sent successfully.");
  }

  displayError() {
    this.AlertManager.showError("An error occured while sending your message. Try again.");
  }

  displayWarning() {
    this.AlertManager.showWarning("The selected contact does not have an email address.");
  }
}

angular.module("thAlertDemo")
  .controller("thAlertDemoCtrl1", DemoCtrl);
