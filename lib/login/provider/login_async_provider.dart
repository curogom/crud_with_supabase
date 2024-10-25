import 'package:crud_with_supabase/common/logger.dart';
import 'package:crud_with_supabase/login/exception/login_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_async_provider.g.dart';

@riverpod
class LoginAsyncNotifier extends _$LoginAsyncNotifier {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> logout() async {
    final supaClient = Supabase.instance.client;
    await supaClient.auth.signOut();
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final supaClient = Supabase.instance.client;

      final res = await supaClient.auth
          .signInWithPassword(
        email: email,
        password: password,
      )
          .timeout(const Duration(seconds: 1), onTimeout: () {
        state = AsyncError(
          CRUDLoginException.wrongIDorPassword,
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

      if (e is AuthException && e.statusCode == '400') {
        exception = CRUDLoginException.wrongIDorPassword;
      } else {
        exception = e;
      }

      state = AsyncError(exception, s);
      return false;
    }
  }
}