import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/vietnam_division_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_state.dart';
import 'edit_profile_screen.dart';
import 'address_list_screen.dart';

class ProfileHubScreen extends StatelessWidget {
  final List<VietnamProvince> provinces;

  const ProfileHubScreen({super.key, required this.provinces});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('TÀI KHOẢN CỦA TÔI'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.neonVolt),
              );
            }

            final profile = (state is ProfileLoaded)
                ? state.profile
                : (state is ProfileUpdatedSuccess)
                    ? state.profile
                    : null;

            if (profile == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<ProfileBloc>().add(LoadProfileEvent()),
                  child: const Text('Tải lại dữ liệu'),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      border: Border.all(color: AppColors.neonVolt.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.black,
                          backgroundImage: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                              ? NetworkImage(profile.avatarUrl!)
                              : null,
                          child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                              ? const Icon(Icons.person, color: AppColors.neonVolt, size: 36)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName,
                                style: GoogleFonts.oswald(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.phoneNumber.isNotEmpty
                                    ? profile.phoneNumber
                                    : profile.email,
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats
                  BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, addrState) {
                      final count = (addrState is AddressLoaded)
                          ? addrState.addresses.length
                          : (addrState is AddressActionSuccess)
                              ? addrState.addresses.length
                              : 0;

                      return _buildStatItem('ĐỊA CHỈ ĐÃ LƯU', '$count địa chỉ');
                    },
                  ),
                  const SizedBox(height: 28),

                  // Section Title
                  Text(
                    'QUẢN LÝ TÀI KHOẢN',
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGray,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Navigation Options List
                  _buildMenuTile(
                    icon: Icons.person_outline,
                    title: 'Chỉnh sửa thông tin cá nhân',
                    subtitle: 'Cập nhật họ tên, SĐT, ngày sinh, ảnh đại diện',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: EditProfileScreen(initialProfile: profile),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Sổ địa chỉ nhận hàng',
                    subtitle: 'Danh mục địa chỉ giao hàng chuẩn 3 cấp Việt Nam',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AddressBloc>(),
                            child: AddressListScreen(provinces: provinces),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Đơn hàng của tôi',
                    subtitle: 'Lịch sử mua hàng, tra cứu mã vận đơn',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tính năng Lịch sử đơn hàng (Sprint 3)...')),
                      );
                    },
                  ),
                  _buildMenuTile(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Kho Voucher & Ưu đãi',
                    subtitle: 'Mã giảm giá thể thao dành riêng cho bạn',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tính năng Voucher (Sprint 3)...')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Nút Đăng xuất
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    icon: const Icon(Icons.logout, size: 20),
                    label: Text(
                      'ĐĂNG XUẤT TÀI KHOẢN',
                      style: GoogleFonts.oswald(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.darkSurface,
                          content: Text('Đã đăng xuất thành công!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.oswald(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const Icon(Icons.location_on_outlined, color: AppColors.neonVolt, size: 24),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: AppColors.white, size: 26),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: AppColors.textGray,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textGray),
        onTap: onTap,
      ),
    );
  }
}
