interface CalendarInterface {
  id: number;
  name: string;
  visible: boolean;
  color: string;
  type?: "AccountCalendar" | "AdhocCalendar" | "UserCalendar";
  permission?: "owner" | "editor" | "viewer" | "limited_viewer" | "none";
};

export default CalendarInterface;
