import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String receiverName;
  final String phoneNumber;
  final String province; // Tỉnh / Thành phố
  final String district; // Quận / Huyện
  final String ward;     // Phường / Xã
  final String streetAddress; // Số nhà, tên đường
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.receiverName,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.ward,
    required this.streetAddress,
    this.isDefault = false,
  });

  String get fullAddress => '$streetAddress, $ward, $district, $province';

  AddressEntity copyWith({
    String? id,
    String? receiverName,
    String? phoneNumber,
    String? province,
    String? district,
    String? ward,
    String? streetAddress,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      receiverName: receiverName ?? this.receiverName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      streetAddress: streetAddress ?? this.streetAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        receiverName,
        phoneNumber,
        province,
        district,
        ward,
        streetAddress,
        isDefault,
      ];
}
