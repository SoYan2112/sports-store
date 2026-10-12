import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final AddressEntity address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final AddressEntity address;

  const UpdateAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;

  const DeleteAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SetDefaultAddressEvent extends AddressEvent {
  final String id;

  const SetDefaultAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}
