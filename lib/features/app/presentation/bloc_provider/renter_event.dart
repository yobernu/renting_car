part of 'renter_bloc.dart';

abstract class RenterEvent extends Equatable {
  const RenterEvent();

  @override
  List<Object> get props => [];
}

class GetRenterByIdEvent extends RenterEvent {
  final String id;

  const GetRenterByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetAllRentersEvent extends RenterEvent {
  const GetAllRentersEvent();
}

class GetRenterByEmailEvent extends RenterEvent {
  final String email;

  const GetRenterByEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}
