import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:iut_lr_app/ical.dart';
import 'package:iut_lr_app/models/course_response.dart';

import '../user.dart';

class CourseRepository {
  static String baseUrl = 'https://www.gpu-lr.fr';
  final CookieJar _cookieJar = CookieJar();
  final Dio _dio = Dio();
  var getCoursesUrl = '$baseUrl/gpu/gpu2vcs.php';

  CourseRepository() {
    _dio..interceptors.add(CookieManager(_cookieJar));
  }

  Future<CourseResponse> getCourses(int week) async {
    var params = {
      'semaine': week,
      'prof_etu': 'ETU',
      'etudiant': await User.studentId,
    };

    try {
      Response response =
          await _dio.get(getCoursesUrl, queryParameters: params);
      return CourseResponse.fromJson(ICAL.icsToJson(response.data));
    } catch (error, stacktrace) {
      print('Exception occurred: $error stackTrace $stacktrace');
    }
  }
}
