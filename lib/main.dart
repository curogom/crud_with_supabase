import 'dart:async';

import 'package:crud_with_supabase/board/page/board_delete_page.dart';
import 'package:crud_with_supabase/board/page/board_detail_page.dart';
import 'package:crud_with_supabase/board/page/board_edit_page.dart';
import 'package:crud_with_supabase/board/page/board_list_page.dart';
import 'package:crud_with_supabase/board/page/board_write_page.dart';
import 'package:crud_with_supabase/home/page/home_page.dart';
import 'package:crud_with_supabase/login/page/login_page.dart';
import 'package:crud_with_supabase/secret.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supaUrl, anonKey: supaApiKey);

  runApp(const ProviderScope(child: CRUDApp()));
}

class CRUDApp extends StatelessWidget {
  const CRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CRUD with Supabase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
