import 'package:rxdart/rxdart.dart';

class SelectedDateBloc {
  BehaviorSubject<DateTime> _subject;

  SelectedDateBloc() {
    DateTime date = DateTime.now();
    _subject = BehaviorSubject<DateTime>.seeded(
        DateTime(date.year, date.month, date.day));
  }

  void setSelectedDate(DateTime date) {
    _subject.sink.add(date);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<DateTime> get subject => _subject;
}

final selectedDateBloc = SelectedDateBloc();
