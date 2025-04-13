class StationsModel {
  List<Station>? stations;
  String? error;

  StationsModel({
    required this.stations,
  });

  StationsModel.withError(String errorMessage) {
    stations = null;
    error = errorMessage;
  }

  factory StationsModel.fromJson(Map<String, dynamic> json) {
    return StationsModel(
      stations: json['stations'] != null
          ? (json['stations'] as List).map((i) => Station.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'stations': stations,
      };
}

class Station {
  int? id;
  String? idName;
  String? name;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  List<Pump> pumps;

  Station({
    required this.id,
    required this.idName,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.pumps,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      idName: json['id_name'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      pumps: json['pumps'] != null
          ? (json['pumps'] as List).map((i) => Pump.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_name': idName,
        'name': name,
        'address': address,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'pumps': pumps,
      };
}

class Pump {
  final int? id;
  final String fuelType;
  final double price;
  final bool available;
  bool deleted;

  Pump({
    this.id,
    required this.fuelType,
    required this.price,
    required this.available,
    this.deleted = false,
  });

  factory Pump.fromJson(Map<String, dynamic> json) {
    return Pump(
      id: json['id'],
      fuelType: json['fuel_type'],
      price: double.parse(json['price'].toString()),
      available: json['available'] == 1 ? true : false,
      deleted: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fuel_type': fuelType,
        'price': price,
        'available': available,
        'deleted': deleted,
      };
}
