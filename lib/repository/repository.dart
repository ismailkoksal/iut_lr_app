import 'package:iut_lr_app/models/course.dart';
import 'package:iut_lr_app/repository/course_repository.dart';

class Repository {
  final CourseRepository _courseRepository;

  const Repository(this._courseRepository);

  Future<List<Course>> loadCourses(int week) =>
      _courseRepository.fetchCourses(week);
}
