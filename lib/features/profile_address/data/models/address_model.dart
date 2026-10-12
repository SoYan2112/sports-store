import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.receiverName,
    required super.phoneNumber,
    required super.province,
    required super.district,
    required super.ward,
    required super.streetAddress,
    super.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      receiverName: json['receiverName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      province: json['province'] as String? ?? '',
      district: json['district'] as String? ?? '',
      ward: json['ward'] as String? ?? '',
      streetAddress: json['streetAddress'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverName': receiverName,
      'phoneNumber': phoneNumber,
      'province': province,
      'district': district,
      'ward': ward,
      'streetAddress': streetAddress,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      receiverName: entity.receiverName,
      phoneNumber: entity.phoneNumber,
      province: entity.province,
      district: entity.district,
      ward: entity.ward,
      streetAddress: entity.streetAddress,
      isDefault: entity.isDefault,
    );
  }
}
