import 'package:crud_with_supabase/login/exception/auth_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_async_provider.g.dart';

@riverpod
class LoginAsyncNotifier extends _$LoginAsyncNotifier {
  late final SupabaseClient _client;

  @override
  FutureOr<void> build() async {
    _client = Supabase.instance.client;
    return null;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = res.session;
      final user = res.user;

      if (session != null && user != null) {
        state = const AsyncData(null);
        return true;
      }

      return false;
    } catch (e, s) {
      Object exception;

      if (e is AuthException && e.statusCode == '400') {
        exception = CRUDAuthException.wrongIDorPassword;
      } else {
        exception = e;
      }

      state = AsyncError(exception, s);
      return false;
    }
  }
}
