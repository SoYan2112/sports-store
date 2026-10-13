import '../../domain/entities/address_entity.dart';
import '../../domain/entities/vietnam_division_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/vietnam_address_local_data.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final ProfileLocalDataSource localDataSource;

  AddressRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AddressEntity>> getAddresses() async {
    return await localDataSource.getAddresses();
  }

  @override
  Future<AddressEntity> addAddress(AddressEntity address) async {
    final model = AddressModel.fromEntity(address);
    return await localDataSource.saveAddress(model);
  }

  @override
  Future<AddressEntity> updateAddress(AddressEntity address) async {
    final model = AddressModel.fromEntity(address);
    return await localDataSource.saveAddress(model);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await localDataSource.deleteAddress(id);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    await localDataSource.setDefaultAddress(id);
  }

  @override
  Future<List<VietnamProvince>> getVietnamDivisions() async {
    return VietnamAddressLocalData.getProvinces();
  }
}
