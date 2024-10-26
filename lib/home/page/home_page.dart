import 'package:crud_with_supabase/board/provider/board_list_provider.dart';
import 'package:crud_with_supabase/login/provider/login_async_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> logout(LoginAsyncNotifier notifier) async {
    await notifier.logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.goNamed('write'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout(ref.read(loginAsyncNotifierProvider.notifier));

              if (context.mounted) {
                context.goNamed('login');
              }
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          _HomeContents(),
        ],
      ),
    );
  }
}

class _HomeContents extends ConsumerWidget {
  const _HomeContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(boardListNotifierProvider);

    if (asyncValue.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (asyncValue.hasError) {
      return Expanded(child: Center(child: Text(asyncValue.error.toString())));
    }

    final list = asyncValue.value ?? [];

    if (list.isEmpty) {
      return const Expanded(child: Center(child: Text('No data')));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return ListTile(
            shape: const Border(bottom: BorderSide(color: Colors.grey)),
            title: Text(item!.name),
            onTap: () {
              context.goNamed(
                'detail',
                pathParameters: {'id': item.id.toString()},
              );
            },
          );
        },
      ),
    );
  }
}
