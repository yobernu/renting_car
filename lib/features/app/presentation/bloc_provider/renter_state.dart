part of 'renter_bloc.dart';

abstract class RenterState extends Equatable {
  const RenterState();

  @override
  List<Object> get props => [];
}

class RenterInitial extends RenterState {}

class RenterLoading extends RenterState {}

class RenterError extends RenterState {
  final String message;

  const RenterError({required this.message});

  @override
  List<Object> get props => [message];
}

class RenterLoaded extends RenterState {
  final Renter renter;

  const RenterLoaded({required this.renter});

  @override
  List<Object> get props => [renter];
}

class RentersListLoaded extends RenterState {
  final List<Renter> renters;

  const RentersListLoaded({required this.renters});

  @override
  List<Object> get props => [renters];
}
