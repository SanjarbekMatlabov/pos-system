import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'auth_repository.dart';
import 'user_model.dart';

part 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final AuthRepository _repository;

  UserManagementCubit(this._repository) : super(UserManagementInitial());

  Future<void> loadUsers() async {
    emit(UserManagementLoading());
    try {
      final users = await _repository.getAllUsers();
      emit(UserManagementLoaded(users));
    } catch (e) {
      emit(UserManagementError("Foydalanuvchilarni yuklashda xatolik: $e"));
    }
  }
  // addUser, updateUser, deleteUser metodlari ham xuddi products_cubit'dagi kabi yoziladi
  // Ular repository'dagi metodni chaqiradi va keyin loadUsers() ni qayta ishga tushiradi.
}