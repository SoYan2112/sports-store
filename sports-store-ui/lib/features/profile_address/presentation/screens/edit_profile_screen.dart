import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_avatar_selector.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfileEntity initialProfile;

  const EditProfileScreen({super.key, required this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  String? _avatarUrl;
  String? _gender;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.fullName);
    _phoneController = TextEditingController(text: widget.initialProfile.phoneNumber);
    _emailController = TextEditingController(text: widget.initialProfile.email);
    _avatarUrl = widget.initialProfile.avatarUrl;
    _gender = widget.initialProfile.gender ?? 'Nam';
    _birthDate = widget.initialProfile.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose;
    _phoneController.dispose;
    _emailController.dispose;
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.white,
              onPrimary: AppColors.black,
              surface: AppColors.darkSurface,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _submitSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProfile = widget.initialProfile.copyWith(
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        avatarUrl: _avatarUrl,
        gender: _gender,
        birthDate: _birthDate,
      );

      context.read<ProfileBloc>().add(UpdateProfileEvent(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.neonVolt,
              content: Text(
                state.message,
                style: GoogleFonts.montserrat(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                state.message,
                style: GoogleFonts.montserrat(color: AppColors.white),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          title: const Text('HỒ SƠ CÁ NHÂN'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatarSelector(
                    currentAvatarUrl: _avatarUrl,
                    onAvatarSelected: (url) {
                      setState(() {
                        _avatarUrl = url;
                      });
                    },
                  ),
                  const SizedBox(height: 28),

                  // Họ và tên
                  _buildSectionLabel('HỌ VÀ TÊN *'),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.montserrat(color: AppColors.white),
                    decoration: _inputDecoration('Nhập họ và tên đầy đủ'),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      if (val.trim().length < 2) {
                        return 'Họ và tên tối thiểu 2 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Số điện thoại Việt Nam
                  _buildSectionLabel('SỐ ĐIỆN THOẠI (VIỆT NAM) *'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.montserrat(color: AppColors.white),
                    decoration: _inputDecoration('Ví dụ: 0901234567'),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      final phoneRegex = RegExp(r'^(0|\+84)(3|5|7|8|9)[0-9]{8}$');
                      if (!phoneRegex.hasMatch(val.trim())) {
                        return 'Số điện thoại không hợp lệ theo chuẩn Việt Nam';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email (Read-only)
                  _buildSectionLabel('EMAIL (KHÔNG THỂ THAY ĐỔI)'),
                  TextFormField(
                    controller: _emailController,
                    enabled: false,
                    style: GoogleFonts.montserrat(color: AppColors.textGray),
                    decoration: _inputDecoration('Email').copyWith(
                      fillColor: AppColors.darkSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ngày sinh
                  _buildSectionLabel('NGÀY SINH'),
                  GestureDetector(
                    onTap: _selectBirthDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _birthDate != null
                                ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                                : 'Chọn ngày sinh',
                            style: GoogleFonts.montserrat(
                              color: _birthDate != null ? AppColors.white : AppColors.textGray,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 18, color: AppColors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Giới tính
                  _buildSectionLabel('GIỚI TÍNH'),
                  Row(
                    children: ['Nam', 'Nữ', 'Khác'].map((genderOption) {
                      final isSelected = _gender == genderOption;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(
                            genderOption,
                            style: GoogleFonts.montserrat(
                              color: isSelected ? AppColors.black : AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.white,
                          backgroundColor: AppColors.darkSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(
                              color: isSelected ? AppColors.white : AppColors.borderGray.withValues(alpha: 0.3),
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _gender = genderOption;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 36),

                  // Nút Lưu
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      final isLoading = state is ProfileUpdating || state is ProfileLoading;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.black,
                          minimumSize: const Size(double.infinity, 54),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        onPressed: isLoading ? null : _submitSave,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black),
                              )
                            : Text(
                                'LƯU THAY ĐỔI',
                                style: GoogleFonts.oswald(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.oswald(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textGray,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 14),
      filled: true,
      fillColor: AppColors.darkSurface,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.3)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    );
  }
}
