import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../user.dart';

class GpuService {
  static CookieJar _cookieJar = CookieJar();
  static Dio _dio = new Dio()..interceptors.add(CookieManager(_cookieJar));
  static String _baseUrl = 'https://www.gpu-lr.fr';
  static final _storage = FlutterSecureStorage();

  static Future<bool> login({@required String studentId}) async {
    print('login');
    FormData formData = new FormData.fromMap({
      'modeconnect': 'connect',
      'util': studentId,
      'acct_pass': '123',
    });

    Response<String> response = await _dio.post(_baseUrl + '/sat/index.php',
        queryParameters: {
          'page_param': 'accueilsatellys.php',
        },
        data: formData);

    if (response.data.contains('CONNEXION ETABLIE')) {
      User.setStudentId(studentId);
      Response<String> response = await _dio.get(
        _baseUrl + '/gpu/index.php',
        queryParameters: {
          'page_param': 'fpetudiant.php',
        },
      );
      Document document = parse(response.data);
      List<String> studentInfo = document
          .querySelector("input[name='etudiant']")
          .parent
          .text
          .split(' ');
      String studentName = studentInfo.sublist(1).join(' ');
      User.setStudentName(studentName);
      return true;
    } else {
      return false;
    }
  }

  static Future reconnect() async {
    FormData formData = new FormData.fromMap({
      'modeconnect': 'connect',
      'util': await User.studentId,
      'acct_pass': '123',
    });

    return await _dio.post(_baseUrl + '/sat/index.php',
        queryParameters: {
          'page_param': 'accueilsatellys.php',
        },
        data: formData);
  }

  static Future<bool> isLoggedIn() async {
    print('isLoggedIn');
    Response response = await _dio.get(
      _baseUrl + '/gpu/index.php',
      queryParameters: {'page_param': 'accueil.php'},
    );

    return !response.data.toString().contains(
        "Cette page n'est pas accessible ou vous n'avez pas les droits suffisants");
  }

  static Future logOut() async {
    return await _dio
        .get(_baseUrl + '/sat/index.php?page_param=deconnect.php')
        .then((_) async => await _storage.deleteAll());
  }
}
