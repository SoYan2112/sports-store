import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final String? token;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.token,
  });

  @override
  List<Object?> get props => [id, fullName, email, phoneNumber, role, token];
}
