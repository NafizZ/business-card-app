import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class LocalDataInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path == '/businesses') {
      // Load local JSON file
      final jsonString = await rootBundle.loadString(
        'assets/data/businesses.json',
      );
      final localData = json.decode(jsonString);
      return handler.resolve(
        Response(requestOptions: options, data: localData, statusCode: 200),
      );
    }
    super.onRequest(options, handler);
  }
}
