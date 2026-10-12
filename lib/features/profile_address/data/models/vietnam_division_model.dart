import '../../domain/entities/vietnam_division_entity.dart';

class VietnamProvinceModel extends VietnamProvince {
  const VietnamProvinceModel({
    required super.id,
    required super.name,
    required super.districts,
  });

  factory VietnamProvinceModel.fromJson(Map<String, dynamic> json) {
    return VietnamProvinceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      districts: (json['districts'] as List<dynamic>? ?? [])
          .map((d) => VietnamDistrictModel.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'districts': districts
          .map((d) => (d as VietnamDistrictModel).toJson())
          .toList(),
    };
  }
}

class VietnamDistrictModel extends VietnamDistrict {
  const VietnamDistrictModel({
    required super.id,
    required super.name,
    required super.wards,
  });

  factory VietnamDistrictModel.fromJson(Map<String, dynamic> json) {
    return VietnamDistrictModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      wards: (json['wards'] as List<dynamic>? ?? [])
          .map((w) => VietnamWardModel.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'wards': wards.map((w) => (w as VietnamWardModel).toJson()).toList(),
    };
  }
}

class VietnamWardModel extends VietnamWard {
  const VietnamWardModel({
    required super.id,
    required super.name,
  });

  factory VietnamWardModel.fromJson(Map<String, dynamic> json) {
    return VietnamWardModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
