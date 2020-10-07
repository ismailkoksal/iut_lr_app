import 'package:dio/dio.dart';
import 'package:iut_lr_app/services/gpu.dart';

class GpuApiInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    await GpuService.isLoggedIn().then((isLoggedIn) async =>
        !isLoggedIn ? await GpuService.reconnect() : null);
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
