import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_api_client/pj_api_client.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';

class AuthNotifier extends StateNotifier<User?> {
  final ApiClient _apiClient;

  AuthNotifier(this._apiClient) : super(null);

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiClient.login(email, password);
      final token = response.data['access_token'];
      final user = User.fromJson(response.data['user']);
      
      _apiClient.setToken(token);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password, String confirmation) async {
    try {
      final response = await _apiClient.register(name, email, password, confirmation, 'customer');
      final token = response.data['access_token'];
      final user = User.fromJson(response.data['user']);
      
      _apiClient.setToken(token);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _apiClient.setToken(null);
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider));
});
