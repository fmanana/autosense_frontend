import 'package:autosense_challenge_frontend/models/station_model.dart';
import 'api_provider.dart';

class APIRepository {
  final _provider = APIProvider();

  Future<StationsModel> getStations() {
    return _provider.getStations();
  }

  Future<StationsModel> updateStation(Station station) {
    return _provider.updateStation(station);
  }

  Future<StationsModel> createStation(Station station) {
    return _provider.createStation(station);
  }

  Future<StationsModel> deleteStation(Station station) {
    return _provider.deleteStation(station);
  }
}

class NetworkError extends Error {}
