import 'package:crud_with_supabase/login/provider/login_async_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController idController;
  late final TextEditingController pwController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    idController = TextEditingController();
    pwController = TextEditingController();
  }

  void listenProvider() {
    ref.listen(loginAsyncNotifierProvider, (oldState, newState) {
      setState(() {
        isLoading = newState.isLoading;
      });

      if (newState.hasError) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(newState.error.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listenProvider();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          _LoginFormWidget(
            idController: idController,
            pwController: pwController,
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoginFormWidget extends ConsumerWidget {
  const _LoginFormWidget({
    required this.idController,
    required this.pwController,
  });

  final TextEditingController idController;
  final TextEditingController pwController;

  Future<bool> _login(LoginAsyncNotifier notifier) async {
    final result = notifier.login(
      email: idController.text,
      password: pwController.text,
    );

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(loginAsyncNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: idController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            obscureText: true,
            controller: pwController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await _login(notifier);

                    if (result && context.mounted) {
                      context.goNamed('home');
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context.pushNamed('sign-up'),
                  child: const Text('Sign-up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
