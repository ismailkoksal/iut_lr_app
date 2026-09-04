import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:iut_lr_app/ical.dart';
import 'package:iut_lr_app/models/course_response.dart';

import '../interceptor.dart';
import '../services/gpu.dart';
import '../user.dart';

/// Levée quand gpu2vcs.php répond autre chose qu'un calendrier : en pratique
/// la page HTML « Erreur 404 » servie lorsque la session n'est pas valide.
class CourseRequestException implements Exception {
  final String message;

  CourseRequestException(this.message);

  @override
  String toString() => 'CourseRequestException: $message';
}

class CourseRepository {
  static String baseUrl = 'https://www.gpu-lr.fr';
  final Dio _dio = Dio();
  var getCoursesUrl = '$baseUrl/gpu/gpu2vcs.php';

  CourseRepository() {
    _dio
      ..interceptors.add(CookieManager(GpuService.cookieJar))
      ..interceptors.add(GpuApiInterceptor());
  }

  Future<CourseResponse> getCourses(int week) async {
    var params = {
      'semaine': week,
      'prof_etu': 'ETU',
      'etudiant': await User.studentId,
    };

    Response response = await _dio.get(getCoursesUrl, queryParameters: params);
    final body = response.data.toString();

    if (!body.contains('BEGIN:VCALENDAR')) {
      throw CourseRequestException(
          'Réponse inattendue pour la semaine $week (session expirée ?)');
    }

    return CourseResponse(week, ICAL.icsToJson(body));
  }
}
