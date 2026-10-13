import '../entities/vietnam_division_entity.dart';
import '../repositories/address_repository.dart';

class GetVietnamDivisionsUseCase {
  final AddressRepository repository;

  GetVietnamDivisionsUseCase(this.repository);

  Future<List<VietnamProvince>> call() async {
    return await repository.getVietnamDivisions();
  }
}
