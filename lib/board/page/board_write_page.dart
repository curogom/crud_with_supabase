import 'dart:convert';

import 'package:crud_with_supabase/board/model/board_detail.dart';
import 'package:crud_with_supabase/board/provider/board_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BoardWritePage extends ConsumerWidget {
  const BoardWritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    Future<void> writeBoard() async {
      final client = Supabase.instance.client;

      final name = titleController.text;
      final content = contentController.text;
      final writerId = client.auth.currentUser!.id;
      final board = BoardDetail(
        name: name,
        content: content,
        writerId: writerId,
      );

      await client.functions.invoke(
        'crud-function',
        method: HttpMethod.post,
        headers: {
          'Authorization': 'Bearer ${client.auth.currentSession?.accessToken}'
        },
        body: json.encode({'board': board.toJson()}),
      );

      ref.invalidate(boardListNotifierProvider);

      if (context.mounted) {
        context.goNamed('home');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write'),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            maxLines: 1,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: TextField(
                minLines: 10,
                maxLines: 20,
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: writeBoard,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
