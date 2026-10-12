import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/vietnam_division_entity.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import '../widgets/address_card_item.dart';
import 'add_edit_address_screen.dart';

class AddressListScreen extends StatelessWidget {
  final List<VietnamProvince> provinces;

  const AddressListScreen({super.key, required this.provinces});

  void _navigateToAddEdit(BuildContext context, [AddressEntity? address]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AddressBloc>(),
          child: AddEditAddressScreen(
            addressToEdit: address,
            provinces: provinces,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressEntity address) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(
          'XÓA ĐỊA CHỈ?',
          style: GoogleFonts.oswald(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa địa chỉ tại "${address.streetAddress}, ${address.ward}" không?',
          style: GoogleFonts.montserrat(color: AppColors.textGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'HỦY',
              style: GoogleFonts.montserrat(color: AppColors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AddressBloc>().add(DeleteAddressEvent(address.id));
            },
            child: const Text('XÓA'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressActionSuccess) {
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
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is AddressError) {
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
          title: const Text('SỔ ĐỊA CHỈ NHẬN HÀNG'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              if (state is AddressLoading && state is! AddressActionSuccess) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.neonVolt),
                );
              }

              List<AddressEntity> addresses = [];
              if (state is AddressLoaded) {
                addresses = state.addresses;
              } else if (state is AddressActionSuccess) {
                addresses = state.addresses;
              }

              return Column(
                children: [
                  Expanded(
                    child: addresses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_off_outlined,
                                  size: 64,
                                  color: AppColors.textGray,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chưa có địa chỉ giao hàng nào',
                                  style: GoogleFonts.oswald(
                                    fontSize: 18,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Thêm địa chỉ để thanh toán nhanh hơn',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return AddressCardItem(
                                address: address,
                                onEdit: () => _navigateToAddEdit(context, address),
                                onDelete: () => _confirmDelete(context, address),
                                onSetDefault: () {
                                  context
                                      .read<AddressBloc>()
                                      .add(SetDefaultAddressEvent(address.id));
                                },
                              );
                            },
                          ),
                  ),

                  // Nút Thêm địa chỉ mới ở đáy
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.darkSurface,
                      border: Border(
                        top: BorderSide(color: AppColors.borderGray, width: 0.2),
                      ),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.black,
                        minimumSize: const Size(double.infinity, 52),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(
                        'THÊM ĐỊA CHỈ MỚI',
                        style: GoogleFonts.oswald(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      onPressed: () => _navigateToAddEdit(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
