import 'package:iut_lr_app/models/course_response.dart';
import 'package:iut_lr_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CoursesListBloc {
  final CourseRepository _repository = CourseRepository();
  final BehaviorSubject<CourseResponse> _subject =
      BehaviorSubject<CourseResponse>();

  getCourses(int week) async {
    _subject.sink.add(null);
    try {
      CourseResponse response = await _repository.getCourses(week);
      response.courses.sort((a, b) => a.dtstart.compareTo(b.dtstart));
      _subject.sink.add(response);
    } catch (error, stacktrace) {
      _subject.sink.addError(error, stacktrace);
    }
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CourseResponse> get subject => _subject;
}

final coursesBloc = CoursesListBloc();
