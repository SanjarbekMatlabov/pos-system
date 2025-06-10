import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salom_pos/features/1_auth/auth_cubit.dart';
import 'package:salom_pos/features/1_auth/auth_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Bu ekran uchun AuthRepository va AuthCubit'ni yaratamiz
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository()),
      child: const LoginView(), // Asosiy UI'ni alohida vidjetga chiqaramiz
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      // BlocListener - holat o'zgarishini tinglaydi, lekin UI'ni qayta chizmaydi.
      // Sahifaga o'tish, xabar chiqarish kabi bir martalik amallar uchun qulay.
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Muvaffaqiyatli kirilsa, kerakli sahifaga o'tkazamiz
            context.goNamed(state.routeName);
          } else if (state is AuthError) {
            // Xatolik bo'lsa, ekranda xabar chiqaramiz
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tizimga kirish',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 32.0),
                    TextFormField(
                      controller: loginController,
                      decoration: const InputDecoration(labelText: 'Login'),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Parol'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 32.0),
                    
                    // BlocBuilder - holat o'zgarishiga qarab UI'ni qayta chizadi.
                    // Masalan, yuklanish indikatorini ko'rsatish/yashirish uchun.
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          // Agar yuklanayotgan bo'lsa, aylanuvchi indikatorni ko'rsatamiz
                          return const Center(child: CircularProgressIndicator());
                        }
                        // Aks holda, Kirish tugmasini ko'rsatamiz
                        return ElevatedButton(
                          onPressed: () {
                            // Cubit'ga login qilish buyrug'ini beramiz
                            context.read<AuthCubit>().loginUser(
                                  username: loginController.text,
                                  password: passwordController.text,
                                );
                          },
                          child: const Text('Kirish'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}