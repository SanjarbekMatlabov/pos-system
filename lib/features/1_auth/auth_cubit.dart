import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salom_pos/features/1_auth/auth_repository.dart';

// --- CUBIT HOLATLARI (STATES) ---

// Barcha holatlar uchun asos (bazoviy) klass
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

// Boshlang'ich holat
class AuthInitial extends AuthState {}

// Ma'lumot yuklanayotgan holat
class AuthLoading extends AuthState {}

// Muvaffaqiyatli kirilgan holat
class AuthSuccess extends AuthState {
  final String routeName; // Qaysi sahifaga o'tish kerakligi
  const AuthSuccess(this.routeName);
  @override
  List<Object> get props => [routeName];
}

// Xatolik yuz bergan holat
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

// --- CUBIT ---

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> loginUser({
    required String username,
    required String password,
  }) async {
    // 1. Yuklanish holatini e'lon qilamiz
    emit(AuthLoading());
    try {
      // 2. Repository orqali ma'lumotlarni tekshiramiz
      final routeName = await _authRepository.login(
        username: username,
        password: password,
      );
      // 3. Muvaffaqiyatli bo'lsa, AuthSuccess holatini e'lon qilamiz
      emit(AuthSuccess(routeName));
    } catch (e) {
      // 4. Xatolik bo'lsa, AuthError holatini e'lon qilamiz
      emit(AuthError(e.toString()));
    }
  }
}