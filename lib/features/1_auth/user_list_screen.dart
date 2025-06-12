import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth_repository.dart';
import 'user_management_cubit.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserManagementCubit(AuthRepository())..loadUsers(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Foydalanuvchilar")),
        floatingActionButton: FloatingActionButton(
          onPressed: () { /* Hali ishlamaydi */ },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            if (state is UserManagementLoading) return const Center(child: CircularProgressIndicator());
            if (state is UserManagementError) return Center(child: Text(state.message));
            if (state is UserManagementLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.username),
                    subtitle: Text(user.role),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}