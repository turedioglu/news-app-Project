import 'package:dio/dio.dart';
import 'package:feature_mind_case/core/init/cache/cache_manager.dart';

class CacheInterceptor extends Interceptor {
  final CacheManager cacheManager = CacheManager.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.method == 'GET') {
      final cachedData = await cacheManager.getValue(options.uri.toString());
      if (cachedData != null) {
        final cachedResponse = Response(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
        );
        handler.resolve(cachedResponse);
        return;
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.method == 'GET') {
      await cacheManager.setValue(response.requestOptions.uri.toString(), response.data);
    }
    super.onResponse(response, handler);
  }
}
