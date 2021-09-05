import 'package:iut_lr_app/models/course.dart';
import 'package:iut_lr_app/repository/repository.dart';
import 'package:mobx/mobx.dart';

part 'course_store.g.dart';

class CourseStore = _CourseStore with _$CourseStore;

abstract class _CourseStore with Store {
  final Repository _repository;

  @observable
  ObservableList<Course> courses = ObservableList<Course>();

  _CourseStore(this._repository);

  @action
  Future<void> loadCourses(int week) async {
    courses = ObservableList.of(await _repository.loadCourses(week));
  }
}
