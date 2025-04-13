part of 'stations_bloc.dart';

abstract class StationsEvent extends Equatable {
  const StationsEvent();

  @override
  List<Object> get props => [];
}

class GetStations extends StationsEvent {}

class UpdateStation extends StationsEvent {
  final Station station;

  const UpdateStation({required this.station});

  @override
  List<Object> get props => [station];
}

class CreateStation extends StationsEvent {
  final Station station;

  const CreateStation({required this.station});

  @override
  List<Object> get props => [station];
}

class DeleteStation extends StationsEvent {
  final Station station;

  const DeleteStation({required this.station});

  @override
  List<Object> get props => [station];
}
