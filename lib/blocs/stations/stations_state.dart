part of 'stations_bloc.dart';

abstract class StationsState extends Equatable {
  const StationsState();

  @override
  List<Object> get props => [];
}

class StationsInitial extends StationsState {}

class StationsLoading extends StationsState {}

class StationsLoaded extends StationsState {
  final StationsModel stationsModel;

  const StationsLoaded({required this.stationsModel});
}

class StationsError extends StationsState {
  final String message;

  const StationsError({required this.message});
}
