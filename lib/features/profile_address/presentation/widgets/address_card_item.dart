import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/address_entity.dart';

class AddressCardItem extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCardItem({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(
          color: address.isDefault ? AppColors.neonVolt : AppColors.borderGray.withValues(alpha: 0.2),
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                address.receiverName,
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '|  ${address.phoneNumber}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: AppColors.textGray,
                ),
              ),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.neonVolt.withValues(alpha: 0.2),
                    border: Border.all(color: AppColors.neonVolt),
                  ),
                  child: Text(
                    'MẶC ĐỊNH',
                    style: GoogleFonts.oswald(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonVolt,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address.fullAddress,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.darkSurface, height: 1),
          Row(
            children: [
              if (!address.isDefault)
                TextButton(
                  onPressed: onSetDefault,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: AppColors.neonVolt,
                  ),
                  child: Text(
                    'Thiết lập mặc định',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neonVolt,
                    ),
                  ),
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.white),
                tooltip: 'Sửa địa chỉ',
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                tooltip: 'Xóa địa chỉ',
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
