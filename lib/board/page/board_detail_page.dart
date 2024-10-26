import 'package:crud_with_supabase/board/model/board_detail.dart';
import 'package:crud_with_supabase/board/provider/board_detail_provider.dart';
import 'package:crud_with_supabase/common/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BoardDetailPage extends ConsumerWidget {
  final String id;

  const BoardDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(boardDetailNotifierProvider(id));
    final notifier = ref.read(boardDetailNotifierProvider(id).notifier);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.hasError) {
      logger.e(state.error, error: state.error, stackTrace: state.stackTrace);
      return const Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    }

    final board = state.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(board.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BoardContent(board: board),
          if (notifier.isWriter)
            _BoardDeleteButton(notifier: notifier, board: board),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BoardDeleteButton extends StatelessWidget {
  const _BoardDeleteButton({
    required this.notifier,
    required this.board,
  });

  final BoardDetailNotifier notifier;
  final BoardDetail board;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () async {
            await notifier.delete('${board.id}');

            if (context.mounted) {
              context.goNamed('home');
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class _BoardContent extends StatelessWidget {
  const _BoardContent({required this.board});

  final BoardDetail board;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: SingleChildScrollView(child: Text(board.content)));
  }
}
