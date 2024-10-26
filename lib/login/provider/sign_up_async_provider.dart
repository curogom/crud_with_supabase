import 'package:crud_with_supabase/common/logger.dart';
import 'package:crud_with_supabase/login/exception/auth_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_up_async_provider.g.dart';

@riverpod
class SignUpAsyncNotifier extends _$SignUpAsyncNotifier {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> logout() async {
    final supaClient = Supabase.instance.client;
    await supaClient.auth.signOut();
  }

  Future<bool> signUp({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final supaClient = Supabase.instance.client;

      final res = await supaClient.auth
          .signUp(
        email: email,
        password: password
      )
          .timeout(const Duration(seconds: 1), onTimeout: () {
        state = AsyncError(
          CRUDAuthException.wrongIDorPassword,
          StackTrace.current,
        );
        return AuthResponse();
      });

      final session = res.session;
      final user = res.user;

      if (session != null && user != null) {
        state = const AsyncData(null);
        return true;
      }

      return false;
    } catch (e, s) {
      Object exception;
      logger.e(e, error: e, stackTrace: s);

      if (e is AuthException) {
        switch (e.statusCode) {
          case '400':
            exception = CRUDAuthException.wrongID;
            break;
          case '422':
            exception = CRUDAuthException.shortPassword;
            break;
          default:
            exception = e;
            break;
        }

      } else {
        exception = e;
      }

      state = AsyncError(exception, s);
      return false;
    }
  }
}
