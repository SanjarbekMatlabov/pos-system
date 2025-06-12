import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'auth_repository.dart';
import 'user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(username, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(const AuthError("Login yoki parol noto'g'ri"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}