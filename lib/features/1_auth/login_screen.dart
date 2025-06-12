import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth_cubit.dart';
import 'auth_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController(text: 'admin');
    final passwordController = TextEditingController(text: 'admin123');

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (state.user.role == 'admin') {
              context.go('/reports'); 
            } else {
              context.go('/pos_terminal'); // Kelajakda kassir ekrani
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tizimga Kirish", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Login')),
                TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Parol'), obscureText: true),
                const SizedBox(height: 20),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().login(usernameController.text, passwordController.text);
                      },
                      child: const Text("Kirish"),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}