import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';

class AuthNotifier extends StateNotifier<User?> {
  final ApiClient _apiClient;
  AuthNotifier(this._apiClient) : super(null);

  Future<void> login(String email, String password) async {
    final response = await _apiClient.login(email, password);
    _apiClient.setToken(response.data['access_token']);
    state = User.fromJson(response.data['user']);
  }

  void logout() { _apiClient.setToken(null); state = null; }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider));
});
