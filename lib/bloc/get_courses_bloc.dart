import 'package:iut_lr_app/models/course_response.dart';
import 'package:iut_lr_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CoursesListBloc {
  final CourseRepository _repository = CourseRepository();
  final BehaviorSubject<CourseResponse> _subject =
      BehaviorSubject<CourseResponse>();

  getCourses(int week) async {
    _subject.sink.add(null);
    CourseResponse response = await _repository.getCourses(week)
      ..courses.sort((a, b) => a.dtstart.compareTo(b.dtend));
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CourseResponse> get subject => _subject;
}

final coursesBloc = CoursesListBloc();
