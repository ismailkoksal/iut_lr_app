import 'package:dio/dio.dart';
import 'package:iut_lr_app/ical.dart';
import 'package:iut_lr_app/models/course.dart';
import 'package:iut_lr_app/models/course_response.dart';

import '../user.dart';

class CourseRepository {
  final Dio _dio;

  const CourseRepository(this._dio);

  Future<List<Course>> fetchCourses(int week) async {
    final params = {
      'semaine': week,
      'prof_etu': 'ETU',
      'etudiant': await User.studentId,
    };

    try {
      final response =
          await _dio.get('/gpu/gpu2vcs.php', queryParameters: params);
      return CourseResponse.fromJson(ICAL.icsToJson(response.data)).courses;
    } catch (error, stacktrace) {
      print('Exception occurred: $error stackTrace $stacktrace');
    }
  }
}
