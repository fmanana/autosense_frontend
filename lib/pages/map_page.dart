import 'package:autosense_challenge_frontend/blocs/stations/stations_bloc.dart';
import 'package:autosense_challenge_frontend/models/station_model.dart';
import 'package:autosense_challenge_frontend/pages/details_page.dart';
import 'package:autosense_challenge_frontend/pages/stations_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// This page is used to display the map and the gas stations on the map as markers
// By clicking a marker the user can see the details of the gas station
// It also has a floating action button to add a new gas station
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late CameraPosition _initialCameraPosition;

  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    // The initial camera position is the center of Switzerland
    BlocProvider.of<StationsBloc>(context).add(GetStations());
    _initialCameraPosition = const CameraPosition(
      target: LatLng(46.8679, 8.2502),
      zoom: 8,
    );
    getCurrentLocation();
  }

  @override
  void dispose() {
    BlocProvider.of<StationsBloc>(context).close();
    _googleMapController?.dispose();
    super.dispose();
  }

  // This function is used for the location permissions to use the phone's GPS
  Future<LocationData?> getLocationPermissions() async {
  Location location = Location();

  try {
    bool serviceEnabled = false;
    try {
      serviceEnabled = await location.serviceEnabled();
    } catch (e) {
      print('Could not determine service status, assuming enabled');
      serviceEnabled = true; // or you can return null if you prefer
    }

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    if (permissionGranted != PermissionStatus.granted &&
        permissionGranted != PermissionStatus.grantedLimited) {
      return null;
    }

    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 10,
    );

    return await location.getLocation();
  } catch (e) {
    print('Error getting location: $e');
    return null;
  }
}


  // This function is used to get the current location of the user using GPS
  Future<void> getCurrentLocation() async {
    LocationData? locationData = await getLocationPermissions();
    if (locationData != null) {
      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 11,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<StationsBloc>(context).add(GetStations());
              getCurrentLocation();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: BlocBuilder<StationsBloc, StationsState>(
            builder: (context, state) {
              if (state is StationsInitial || state is StationsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StationsLoaded) {
                return Scaffold(
                  body: GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    markers: state.stationsModel.stations
                        ?.map(
                          (Station e) => Marker(
                            markerId: MarkerId(e.idName!),
                            position: LatLng(e.latitude!, e.longitude!),
                            infoWindow: InfoWindow(
                              title: e.name,
                              snippet: e.address,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(station: e),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .toSet() as Set<Marker>,
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: "MyLocationButton",
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          foregroundColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            getCurrentLocation();
                          },
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          width: 100,
                          child: FloatingActionButton(
                            heroTag: "AddButton",
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StationsForm(),
                                ),
                              );
                            },
                            child: Text(
                              "Add Station",
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.merge(
                                        TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 55,
                          width: 55,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is StationsError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
