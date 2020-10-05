import 'package:dio/dio.dart';
import 'package:iut_lr_app/services/gpu.dart';
import 'package:iut_lr_app/user.dart';

class GpuApiInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    GpuService.isLoggedIn().then((isLoggedIn) async => !isLoggedIn
        ? await GpuService.login(studentId: await User.studentId)
        : null);
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}
