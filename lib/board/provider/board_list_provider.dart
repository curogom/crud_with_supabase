import 'package:crud_with_supabase/board/model/board_detail.dart';
import 'package:crud_with_supabase/common/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'board_list_provider.g.dart';

@riverpod
class BoardListNotifier extends _$BoardListNotifier {
  @override
  FutureOr<List<dynamic>> build() async {
    try {
      final client = Supabase.instance.client;
      final response = await client.functions.invoke(
        'crud-function',
        method: HttpMethod.get,
      );

      logger.d(response.data);

      final list = response.data?['boards']
          .map((e) => BoardDetail.fromJson(e))
          .toList();

      return list ?? [];
    } catch (e, s) {
      logger.e(e, error: e, stackTrace: s);
      rethrow;
    }
  }
}
