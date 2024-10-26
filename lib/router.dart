part of 'main.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    homeRouter,
    loginRouter,
  ],
  redirect: routeRedirect,
);

FutureOr<String?> routeRedirect(
    BuildContext context, GoRouterState state) async {
  final supaClient = Supabase.instance.client;

  if (state.fullPath?.contains('login') ?? false) {
    if (supaClient.auth.currentUser != null) {
      return '/home';
    }
    return null;
  }

  if (supaClient.auth.currentUser == null) {
    return '/login';
  }
  return null;
}

final homeRouter = GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomePage(),
  routes: [
    GoRoute(
      path: 'write',
      name: 'write',
      builder: (context, state) => const BoardWritePage(),
    ),
    GoRoute(
      path: 'detail/:id',
      name: 'detail',
      builder: (context, state) =>
          BoardDetailPage(id: state.pathParameters['id']!),
    ),
  ],
);

final loginRouter = GoRoute(
  path: '/login',
  name: 'login',
  builder: (context, state) => const LoginPage(),
  routes: [
    GoRoute(
      path: 'sign-up',
      name: 'sign-up',
      builder: (context, state) => const SignUpPage(),
    ),
  ],
);
