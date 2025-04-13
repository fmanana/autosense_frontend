import 'package:autosense_challenge_frontend/models/station_model.dart';
import 'package:autosense_challenge_frontend/resources/api_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stations_event.dart';
part 'stations_state.dart';

class StationsBloc extends Bloc<StationsEvent, StationsState> {
  StationsBloc() : super(StationsInitial()) {
    final APIRepository apiRepository = APIRepository();

    // This bloc event is used to get the gas stations from the API
    on<GetStations>((event, emit) async {
      try {
        emit(StationsLoading());
        final StationsModel stationsModel = await apiRepository.getStations();
        emit(StationsLoaded(stationsModel: stationsModel));
        if (stationsModel.error != null) {
          emit(StationsError(message: stationsModel.error!));
        }
      } catch (error) {
        if (error is NetworkError) {
          emit(const StationsError(
              message: "Couldn't fetch data. Is the device online?"));
        } else {
          emit(StationsError(message: error.toString()));
        }
      }
    });

    // This bloc event is used to update a gas station
    on<UpdateStation>((event, emit) async {
      try {
        final StationsModel stationsModel =
            await apiRepository.updateStation(event.station);

        // This is used to refresh the list of gas stations after updating one
        add(GetStations());

        if (stationsModel.error != null) {
          emit(StationsError(message: stationsModel.error!));
        }
      } catch (error) {
        if (error is NetworkError) {
          emit(const StationsError(
              message: "Couldn't update station. Is the device online?"));
        } else {
          emit(StationsError(message: error.toString()));
        }
      }
    });

    // This bloc event is used to create a new gas station
    on<CreateStation>((event, emit) async {
      try {
        final StationsModel stationsModel =
            await apiRepository.createStation(event.station);

        // This is used to refresh the list of gas stations after creating one
        add(GetStations());

        if (stationsModel.error != null) {
          emit(StationsError(message: stationsModel.error!));
        }
      } catch (error) {
        if (error is NetworkError) {
          emit(const StationsError(
              message: "Couldn't create station. Is the device online?"));
        } else {
          emit(StationsError(message: error.toString()));
        }
      }
    });

    // This bloc event is used to delete a gas station
    on<DeleteStation>((event, emit) async {
      try {
        final StationsModel stationsModel =
            await apiRepository.deleteStation(event.station);

        // This is used to refresh the list of gas stations after deleting one
        add(GetStations());

        if (stationsModel.error != null) {
          emit(StationsError(message: stationsModel.error!));
        }
      } catch (error) {
        if (error is NetworkError) {
          emit(const StationsError(
              message: "Couldn't delete station. Is the device online?"));
        } else {
          emit(StationsError(message: error.toString()));
        }
      }
    });
  }
}
