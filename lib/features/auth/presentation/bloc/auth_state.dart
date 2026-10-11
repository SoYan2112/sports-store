import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String emailOrPhone;
  final String password;
  const LoginEvent({required this.emailOrPhone, required this.password});
  @override
  List<Object?> get props => [emailOrPhone, password];
}

class RegisterEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  const RegisterEvent({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });
  @override
  List<Object?> get props => [fullName, email, phone, password];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  const ForgotPasswordEvent(this.email);
  @override
  List<Object?> get props => [email];
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class ForgotPasswordSent extends AuthState {
  final String email;
  const ForgotPasswordSent(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
