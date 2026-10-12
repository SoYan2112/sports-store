import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/vietnam_division_entity.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../widgets/vietnam_address_dropdowns.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressEntity? addressToEdit;
  final List<VietnamProvince> provinces;

  const AddEditAddressScreen({
    super.key,
    this.addressToEdit,
    required this.provinces,
  });

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;

  String _selectedProvince = '';
  String _selectedDistrict = '';
  String _selectedWard = '';
  bool _isDefault = false;

  bool get isEditing => widget.addressToEdit != null;

  @override
  void initState() {
    super.initState();
    final address = widget.addressToEdit;
    _nameController = TextEditingController(text: address?.receiverName ?? '');
    _phoneController = TextEditingController(text: address?.phoneNumber ?? '');
    _streetController = TextEditingController(text: address?.streetAddress ?? '');
    _isDefault = address?.isDefault ?? false;
    _selectedProvince = address?.province ?? '';
    _selectedDistrict = address?.district ?? '';
    _selectedWard = address?.ward ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose;
    _phoneController.dispose;
    _streetController.dispose;
    super.dispose();
  }

  void _submitAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedProvince.isEmpty || _selectedDistrict.isEmpty || _selectedWard.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.warning,
            content: Text('Vui lòng chọn đầy đủ Tỉnh/Thành, Quận/Huyện, Phường/Xã'),
          ),
        );
        return;
      }

      final address = AddressEntity(
        id: widget.addressToEdit?.id ?? const Uuid().v4(),
        receiverName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        province: _selectedProvince,
        district: _selectedDistrict,
        ward: _selectedWard,
        streetAddress: _streetController.text.trim(),
        isDefault: _isDefault,
      );

      if (isEditing) {
        context.read<AddressBloc>().add(UpdateAddressEvent(address));
      } else {
        context.read<AddressBloc>().add(AddAddressEvent(address));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(isEditing ? 'CHỈNH SỬA ĐỊA CHỈ' : 'THÊM ĐỊA CHỈ MỚI'),
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
                _buildLabel('HỌ VÀ TÊN NGƯỜI NHẬN *'),
                TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.montserrat(color: AppColors.white),
                  decoration: _inputDecoration('Nguyễn Văn A'),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Vui lòng nhập tên người nhận hàng';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                _buildLabel('SỐ ĐIỆN THOẠI NHẬN HÀNG (VIỆT NAM) *'),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.montserrat(color: AppColors.white),
                  decoration: _inputDecoration('Ví dụ: 0912345678'),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    final phoneRegex = RegExp(r'^(0|\+84)(3|5|7|8|9)[0-9]{8}$');
                    if (!phoneRegex.hasMatch(val.trim())) {
                      return 'Số điện thoại không đúng định dạng Việt Nam';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Dropdown 3 cấp
                VietnamAddressDropdowns(
                  provinces: widget.provinces,
                  initialProvince: widget.addressToEdit?.province,
                  initialDistrict: widget.addressToEdit?.district,
                  initialWard: widget.addressToEdit?.ward,
                  onChanged: (prov, dist, ward) {
                    _selectedProvince = prov;
                    _selectedDistrict = dist;
                    _selectedWard = ward;
                  },
                ),
                const SizedBox(height: 18),

                _buildLabel('ĐỊA CHỈ CỤ THỂ (SỐ NHÀ, TÊN ĐƯỜNG) *'),
                TextFormField(
                  controller: _streetController,
                  style: GoogleFonts.montserrat(color: AppColors.white),
                  decoration: _inputDecoration('Số 123 Đường Nguyễn Trãi'),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Vui lòng nhập địa chỉ cụ thể';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Switch Đặt làm mặc định
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đặt làm địa chỉ mặc định',
                        style: GoogleFonts.montserrat(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Switch(
                        value: _isDefault,
                        activeThumbColor: AppColors.neonVolt,
                        onChanged: (val) {
                          setState(() {
                            _isDefault = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Button Lưu
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.black,
                    minimumSize: const Size(double.infinity, 54),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: _submitAddress,
                  child: Text(
                    isEditing ? 'LƯU THAY ĐỔI ĐỊA CHỈ' : 'HOÀN TẤT THÊM ĐỊA CHỈ',
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
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
