import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import '../models/address_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> saveProfile(UserProfileModel profile);
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> saveAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _profileKey = 'CACHED_USER_PROFILE';
  static const String _addressListKey = 'CACHED_ADDRESS_LIST';

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserProfileModel> getProfile() async {
    final jsonString = sharedPreferences.getString(_profileKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> map = jsonDecode(jsonString);
        return UserProfileModel.fromJson(map);
      } catch (_) {}
    }

    // Default seeded profile
    final defaultProfile = UserProfileModel(
      id: 'USR_VN_001',
      fullName: 'Nguyễn Văn Hùng',
      email: 'hung.nguyen@sports.vn',
      phoneNumber: '0901234567',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      gender: 'Nam',
      birthDate: DateTime(1998, 5, 20),
    );
    await saveProfile(defaultProfile);
    return defaultProfile;
  }

  @override
  Future<UserProfileModel> saveProfile(UserProfileModel profile) async {
    final jsonString = jsonEncode(profile.toJson());
    await sharedPreferences.setString(_profileKey, jsonString);
    return profile;
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final jsonString = sharedPreferences.getString(_addressListKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        return list
            .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    // Default seeded addresses (Vietnam standard)
    final defaultAddresses = [
      const AddressModel(
        id: 'ADDR_01',
        receiverName: 'Nguyễn Văn Hùng',
        phoneNumber: '0901234567',
        province: 'Hồ Chí Minh',
        district: 'Quận 1',
        ward: 'Phường Bến Nghé',
        streetAddress: 'Số 123 Đường Lê Lợi',
        isDefault: true,
      ),
      const AddressModel(
        id: 'ADDR_02',
        receiverName: 'Nguyễn Văn Hùng (Văn phòng)',
        phoneNumber: '0987654321',
        province: 'Hà Nội',
        district: 'Cầu Giấy',
        ward: 'Phường Dịch Vọng',
        streetAddress: 'Tòa nhà FPT Cầu Giấy, Đường Duy Tân',
        isDefault: false,
      ),
    ];
    await _saveAddressList(defaultAddresses);
    return defaultAddresses;
  }

  Future<void> _saveAddressList(List<AddressModel> list) async {
    final jsonString = jsonEncode(list.map((a) => a.toJson()).toList());
    await sharedPreferences.setString(_addressListKey, jsonString);
  }

  @override
  Future<AddressModel> saveAddress(AddressModel address) async {
    final list = await getAddresses();
    final index = list.indexWhere((item) => item.id == address.id);

    List<AddressModel> updatedList = List.from(list);
    if (address.isDefault) {
      // Unmark all other defaults
      updatedList = updatedList
          .map((a) => a.copyWith(isDefault: false) as AddressModel)
          .toList();
    }

    if (index >= 0) {
      updatedList[index] = address;
    } else {
      // If this is the only address, make it default
      final toAdd = updatedList.isEmpty
          ? (address.copyWith(isDefault: true) as AddressModel)
          : address;
      updatedList.add(toAdd);
    }

    await _saveAddressList(updatedList);
    return address;
  }

  @override
  Future<void> deleteAddress(String id) async {
    final list = await getAddresses();
    final updatedList = list.where((item) => item.id != id).toList();
    // If the deleted address was default and list is not empty, set the first one as default
    if (list.any((a) => a.id == id && a.isDefault) && updatedList.isNotEmpty) {
      updatedList[0] = (updatedList[0].copyWith(isDefault: true) as AddressModel);
    }
    await _saveAddressList(updatedList);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    final list = await getAddresses();
    final updatedList = list.map((a) {
      return (a.copyWith(isDefault: a.id == id) as AddressModel);
    }).toList();
    await _saveAddressList(updatedList);
  }
}
