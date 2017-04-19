import CalendarEntryInterface from "../../calendar-entry.interface";

export default class EditModalController {

  private modal: any;
  private calendarEntry: CalendarEntryInterface;
  private saveData: Function;
  private isNewEntry: boolean;

  constructor (modal: any) {
    this.modal = modal;
    this.saveData = modal.context.onSave;
    this.calendarEntry = modal.context.calendarEntry;
    this.isNewEntry = modal.context.isNew;
  }

  dismiss() {
    new Promise((resolve) => {
      // Todo: clear the changes to the DataSource
      resolve();
    })
      .then(() => {
        this.modal.dismiss();
      });
  }

  confirm() {
    this.saveData(this.calendarEntry, this.isNewEntry);
    this.modal.confirm();
  }
}
