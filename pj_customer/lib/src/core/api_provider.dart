import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';

const String _defaultBaseUrl = kIsWeb
    ? 'http://localhost:8000'
    : (defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8000'
        : 'http://localhost:8000');

final String _baseUrl = String.fromEnvironment('BASE_URL', defaultValue: _defaultBaseUrl);

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: _baseUrl);
});
