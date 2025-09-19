import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/core/usecases/usecases.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';
import 'package:renting_car/features/app/domain/usecases/get_all_renters.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_id.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_email.dart';

part 'renter_event.dart';
part 'renter_state.dart';

class RenterBloc extends Bloc<RenterEvent, RenterState> {
  final GetRenterById getRenterById;
  final GetAllRentersUsecase getAllRenters;
  final GetRenterByEmailUsecase getRenterByEmail;

  RenterBloc({
    required this.getRenterById,
    required this.getAllRenters,
    required this.getRenterByEmail,
  }) : super(RenterInitial()) {
    on<GetRenterByIdEvent>(_onGetRenterById);
    on<GetAllRentersEvent>(_onGetAllRenters);
    on<GetRenterByEmailEvent>(_onGetRenterByEmail);
  }

  Future<void> _onGetRenterById(
    GetRenterByIdEvent event,
    Emitter<RenterState> emit,
  ) async {
    emit(RenterLoading());
    final result = await getRenterById(event.id);
    emit(_mapFailureOrRenterToState(result));
  }

  Future<void> _onGetAllRenters(
    GetAllRentersEvent event,
    Emitter<RenterState> emit,
  ) async {
    emit(RenterLoading());
    final result = await getAllRenters(NoParams());
    emit(_mapFailureOrRentersListToState(result));
  }

  Future<void> _onGetRenterByEmail(
    GetRenterByEmailEvent event,
    Emitter<RenterState> emit,
  ) async {
    emit(RenterLoading());
    final result = await getRenterByEmail(event.email);
    emit(_mapFailureOrRenterToState(result));
  }

  RenterState _mapFailureOrRenterToState(Either<Failure, Renter> either) {
    return either.fold(
      (failure) => RenterError(message: _mapFailureToMessage(failure)),
      (renter) => RenterLoaded(renter: renter),
    );
  }

  RenterState _mapFailureOrRentersListToState(
    Either<Failure, List<Renter>> either,
  ) {
    return either.fold(
      (failure) => RenterError(message: _mapFailureToMessage(failure)),
      (renters) => RentersListLoaded(renters: renters),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error occurred';
    } else if (failure is CacheFailure) {
      return 'Cache error occurred';
    } else if (failure.toString().contains('No internet connection') || 
               failure.toString().contains('network')) {
      return 'No internet connection';
    } else if (failure.toString().contains('not found') || 
               failure.toString().contains('not_found')) {
      return 'Renter not found';
    } else {
      return 'Unexpected error occurred';
    }
  }
}
