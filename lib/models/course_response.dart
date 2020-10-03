import 'package:iut_lr_app/models/course.dart';

class CourseResponse {
  final List<Course> courses;

  CourseResponse(this.courses);

  CourseResponse.fromJson(List<dynamic> json)
      : courses = json.map((e) => Course.fromJson(e)).toList();
}
