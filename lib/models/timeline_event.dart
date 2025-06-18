// lib/models/timeline_event.dart
class TimelineEvent {
  final String date;
  final String title;
  final int startYear;
  final String? details;
  const TimelineEvent(this.date, this.title, this.startYear, {this.details});
}