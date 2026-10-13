import '../entities/address_entity.dart';
import '../entities/vietnam_division_entity.dart';

abstract class AddressRepository {
  Future<List<AddressEntity>> getAddresses();
  Future<AddressEntity> addAddress(AddressEntity address);
  Future<AddressEntity> updateAddress(AddressEntity address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
  Future<List<VietnamProvince>> getVietnamDivisions();
}
