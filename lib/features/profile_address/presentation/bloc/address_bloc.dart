import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  AddressBloc({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  }) : super(AddressInitial()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await getAddressesUseCase();
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError('Lỗi tải danh sách địa chỉ: ${e.toString()}'));
    }
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await addAddressUseCase(event.address);
      final addresses = await getAddressesUseCase();
      emit(AddressActionSuccess(
        message: 'Thêm địa chỉ giao hàng thành công!',
        addresses: addresses,
      ));
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError('Thêm địa chỉ thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await updateAddressUseCase(event.address);
      final addresses = await getAddressesUseCase();
      emit(AddressActionSuccess(
        message: 'Cập nhật địa chỉ thành công!',
        addresses: addresses,
      ));
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError('Cập nhật địa chỉ thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await deleteAddressUseCase(event.id);
      final addresses = await getAddressesUseCase();
      emit(AddressActionSuccess(
        message: 'Đã xóa địa chỉ khỏi sổ tay!',
        addresses: addresses,
      ));
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError('Xóa địa chỉ thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      await setDefaultAddressUseCase(event.id);
      final addresses = await getAddressesUseCase();
      emit(AddressActionSuccess(
        message: 'Đã đặt làm địa chỉ mặc định!',
        addresses: addresses,
      ));
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError('Cài đặt mặc định thất bại: ${e.toString()}'));
    }
  }
}
