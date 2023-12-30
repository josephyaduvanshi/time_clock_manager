class RecentWeekModel {
  final String title, date;
  double hours;

  RecentWeekModel(
      {required this.title, required this.date, required this.hours});
}

List recentWeekModelList = [
  RecentWeekModel(
    title: "Sunday",
    date: "01-03-2021",
    hours: 8.8,
  ),
  RecentWeekModel(
    title: "Monday",
    date: "27-02-2021",
    hours: 1.5,
  ),
  RecentWeekModel(
    title: "Tuesday",
    date: "23-02-2021",
    hours: 3,
  ),
  RecentWeekModel(
    title: "Wednesday",
    date: "21-02-2021",
    hours: 3.5,
  ),
  RecentWeekModel(
    title: "Thursday",
    date: "23-02-2021",
    hours: 2.5,
  ),
  RecentWeekModel(
    title: "Friday",
    date: "25-02-2021",
    hours: 3.5,
  ),
  RecentWeekModel(
    title: "Saturday",
    date: "25-02-2021",
    hours: 3,
  ),
];
