import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pj_api_client/pj_api_client.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_provider.dart';

class AuthNotifier extends StateNotifier<User?> {
  final ApiClient _apiClient;

  AuthNotifier(this._apiClient) : super(null);

  Future<void> login(String email, String password, String adminKey) async {
    try {
      // Keep the admin key in the flow, but authenticate against backend.
      if (adminKey.trim().isEmpty) {
        throw Exception('کلیلی ئەدمین پێویستە');
      }

      final response = await _apiClient.login(
        email,
        password,
        adminKey: adminKey.trim(),
      );
      final data = Map<String, dynamic>.from(response.data as Map);
      final token = data['access_token'] as String?;
      final rawUser = data['user'];
      if (token == null || rawUser is! Map) {
        throw Exception('وەڵامی چوونەژوورەوە لە ڕاژەکارەوە دروست نییە');
      }

      final user = User.fromJson(Map<String, dynamic>.from(rawUser));
      _apiClient.setToken(token);
      state = user.copyWith(
        isOwner: user.isOwner || user.role == UserRole.superAdmin,
      );
    } on DioException catch (e) {
      final message =
          (e.response?.data is Map && e.response?.data['message'] is String)
          ? e.response!.data['message'] as String
          : e.message ?? 'چوونەژوورەوە سەرکەوتوو نەبوو';
      throw Exception(message);
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

class LastKeyChangeNotifier extends StateNotifier<DateTime> {
  LastKeyChangeNotifier(this._prefs) : super(_loadInitialValue(_prefs));

  static const _storageKey = 'admin_last_key_change_at';
  final SharedPreferences _prefs;

  static DateTime _loadInitialValue(SharedPreferences prefs) {
    final stored = prefs.getString(_storageKey);
    if (stored == null || stored.isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(stored) ?? DateTime.now();
  }

  Future<void> markChangedNow() async {
    final now = DateTime.now();
    await _prefs.setString(_storageKey, now.toIso8601String());
    state = now;
  }
}

final lastKeyChangeProvider =
    StateNotifierProvider<LastKeyChangeNotifier, DateTime>((ref) {
      return LastKeyChangeNotifier(ref.watch(sharedPreferencesProvider));
    });
