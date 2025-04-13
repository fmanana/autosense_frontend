import 'package:autosense_challenge_frontend/models/station_model.dart';
import 'package:dio/dio.dart';

// This class is used to make API calls
class APIProvider {
  final Dio _dio = Dio();
  final String _url = 'http://10.0.2.2:4000/stations/';
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEyMzQ1Njc4OTAiLCJpYXQiOjE3NDQ0ODUwMzgsImV4cCI6MTc0NTA4OTgzOH0.lzxpBdW9cQina-XArWGnmaSxRdSflQypPLI7DsXvU_s";

  Future<StationsModel> getStations() async {
    try {
      final response = await _dio.get(
        _url,
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      return StationsModel.fromJson(response.data);
    } catch (error) {
      return StationsModel.withError("Data not found / Connection issue");
    }
  }

  Future<StationsModel> updateStation(Station station) async {
    try {
      final response = await _dio.put(
        _url + station.id.toString(),
        data: station.toJson(),
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      return StationsModel.fromJson(response.data);
    } catch (error) {
      return StationsModel.withError("Error updating data");
    }
  }

  Future<StationsModel> createStation(Station station) async {
    try {
      final response = await _dio.post(
        _url,
        data: station.toJson(),
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      return StationsModel.fromJson(response.data);
    } catch (error) {
      return StationsModel.withError("Error creating station");
    }
  }

  Future<StationsModel> deleteStation(Station station) async {
    try {
      final response = await _dio.delete(
        _url + station.id.toString(),
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      return StationsModel.fromJson(response.data);
    } catch (error) {
      return StationsModel.withError("Error deleting data");
    }
  }
}
