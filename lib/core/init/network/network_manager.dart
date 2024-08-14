import 'package:dio/dio.dart';
import 'package:feature_mind_case/core/base/model/base_model.dart';
import 'package:feature_mind_case/core/constants/app_constants.dart';
import 'package:feature_mind_case/core/init/network/cache_network_request.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init() {
    initManager();
  }

  initManager() async {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: ApplicationConstants.instance.baseURL,
      headers: {
        "Charset": "utf-8",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.add(CacheInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseData: true,
          ),
        ),
      );
    }
  }

  late Dio _dio;

  Dio get dio => _dio;

  Future get<T extends IBaseModel>({
    required String path,
    required T model,
    Map<String, dynamic>? queryParameters,
  }) async {
    dynamic responseData;
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      responseData = _jsonBodyParser<T>(model, response.data);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
    return responseData;
  }

  Future post<T extends IBaseModel>({
    required String path,
    required T model,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    dynamic responseData;
    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      responseData = _jsonBodyParser<T>(model, response.data);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
    return responseData;
  }

  dynamic _jsonBodyParser<T>(IBaseModel model, dynamic jsonBody) async {
    try {
      if (jsonBody is List) {
        return jsonBody.map((e) => model.fromJson(e)).toList().cast<T>();
      } else if (jsonBody is Map) {
        return model.fromJson(jsonBody);
      } else {
        return jsonBody;
      }
    } catch (ex) {
      return jsonBody;
    }
  }
}
