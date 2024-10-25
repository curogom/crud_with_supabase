part of 'main.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    homeRouter,
    loginRouter,
    boardRouter,
  ],
  redirect: routeRedirect,
);

FutureOr<String?> routeRedirect(context, state) async {
  final supaClient = Supabase.instance.client;
  if (supaClient.auth.currentUser == null) {
    return '/login';
  }
  return null;
}

final homeRouter = GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomePage(),
);

final loginRouter = GoRoute(
  path: '/login',
  name: 'login',
  builder: (context, state) => const LoginPage(),
);

final boardRouter = GoRoute(
  path: '/board',
  name: 'board',
  builder: (context, state) => const BoardListPage(),
  routes: [
    boardDetailRouter,
    boardEditRouter,
    boardWriteRouter,
    boardDeleteRouter,
  ],
);

final boardDetailRouter = GoRoute(
  path: '/:id',
  name: 'detail',
  builder: (context, state) => BoardDetailPage(id: state.pathParameters['id']),
);

final boardEditRouter = GoRoute(
  path: '/:id/edit',
  name: 'edit',
  builder: (context, state) => BoardEditPage(id: state.pathParameters['id']),
);

final boardWriteRouter = GoRoute(
  path: '/write',
  name: 'write',
  builder: (context, state) => const BoardWritePage(),
);

final boardDeleteRouter = GoRoute(
  path: '/:id/delete',
  name: 'delete',
  builder: (context, state) => BoardDeletePage(id: state.pathParameters['id']),
);