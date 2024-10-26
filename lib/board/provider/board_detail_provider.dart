import 'package:crud_with_supabase/board/model/board_detail.dart';
import 'package:crud_with_supabase/board/provider/board_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'board_detail_provider.g.dart';

@riverpod
class BoardDetailNotifier extends _$BoardDetailNotifier {
  late final SupabaseClient _client;

  @override
  FutureOr<BoardDetail> build(String id) async {
    _client = Supabase.instance.client;

    final res = await _client.functions.invoke(
      'crud-function',
      queryParameters: {'id': id},
      method: HttpMethod.get,
    );

    final board = BoardDetail.fromJson(res.data['board'].first);

    return board;
  }

  bool get isWriter => _client.auth.currentUser?.id == state.value?.writerId;

  Future<void> delete(String id) async {
    await _client.functions.invoke(
      'crud-function',
      queryParameters: {'id': id},
      method: HttpMethod.delete,
    );

    ref.invalidate(boardListNotifierProvider);
  }
}
