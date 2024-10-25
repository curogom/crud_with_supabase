import 'package:crud_with_supabase/common/logger.dart';
import 'package:crud_with_supabase/login/provider/login_async_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(loginAsyncNotifierProvider.notifier).logout();

              logger.d(context.mounted);

              if (context.mounted) {
                context.goNamed('login');
              }
            },
          ),
        ],
      ),
      body: Center(child: Text('Home'),),
    );
  }
}
