import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_store_mobile/core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ĐĂNG KÝ'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.success,
                content: Text('Đăng ký tài khoản thành công!'),
              ),
            );
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.error,
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'GIA NHẬP ĐỘI NGŨ',
                    style: GoogleFonts.oswald(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tạo hồ sơ thể thao cá nhân của bạn ngay hôm nay.',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'HỌ VÀ TÊN',
                      prefixIcon: Icon(Icons.badge_outlined, color: AppColors.textGray),
                    ),
                    validator: (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập Họ tên' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'ĐỊA CHỈ EMAIL',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textGray),
                    ),
                    validator: (val) {
                      if (val == null || !val.contains('@')) {
                        return 'Vui lòng nhập Email hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'SỐ ĐIỆN THOẠI (+84)',
                      prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textGray),
                    ),
                    validator: (val) {
                      if (val == null || val.length < 9) {
                        return 'Vui lòng nhập SĐT Việt Nam hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'MẬT KHẨU (TỐI THIỂU 6 KÝ TỰ)',
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.textGray),
                    ),
                    validator: (val) => (val == null || val.length < 6) ? 'Mật khẩu quá ngắn' : null,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: isLoading ? null : _onRegister,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                          )
                        : const Text('TẠO TÀI KHOẢN'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
