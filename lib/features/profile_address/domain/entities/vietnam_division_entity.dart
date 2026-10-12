import 'package:equatable/equatable.dart';

class VietnamProvince extends Equatable {
  final String id;
  final String name;
  final List<VietnamDistrict> districts;

  const VietnamProvince({
    required this.id,
    required this.name,
    this.districts = const [],
  });

  @override
  List<Object?> get props => [id, name, districts];
}

class VietnamDistrict extends Equatable {
  final String id;
  final String name;
  final List<VietnamWard> wards;

  const VietnamDistrict({
    required this.id,
    required this.name,
    this.wards = const [],
  });

  @override
  List<Object?> get props => [id, name, wards];
}

class VietnamWard extends Equatable {
  final String id;
  final String name;

  const VietnamWard({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
