interface CalendarEntryInterface {
  id?: number;
  title: string;
  start: any;
  end: any;
  // TODO: unify format for calendar id prop.
  calendar?: {
    id: number,
  };
  calendar_id?: number;
  [propName: string]: any;
};

export default CalendarEntryInterface;
