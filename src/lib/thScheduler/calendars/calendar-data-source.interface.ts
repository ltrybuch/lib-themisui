import CalendarInterface from "./calendar.interface";

interface CalendarDataSourceInterface {
  getIds(): Promise<number[]>;
  isVisible(id: number): boolean;
  setVisible(calendar: CalendarInterface): void;
  bind(eventName: string, handler: Function): void;
}

export default CalendarDataSourceInterface;
