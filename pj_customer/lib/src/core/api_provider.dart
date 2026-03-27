import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';

const String _defaultBaseUrl = 'https://ltsmapi.45.32.155.226.sslip.io';

const String _configuredBaseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: '',
);

final String apiBaseUrl = _configuredBaseUrl.isNotEmpty
    ? _configuredBaseUrl
    : _defaultBaseUrl;

String resolveApiUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }

  final normalizedBase = apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return '$normalizedBase$normalizedPath';
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: apiBaseUrl);
});
