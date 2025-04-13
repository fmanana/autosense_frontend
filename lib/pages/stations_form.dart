import 'package:autosense_challenge_frontend/blocs/stations/stations_bloc.dart';
import 'package:autosense_challenge_frontend/models/station_model.dart';
import 'package:autosense_challenge_frontend/widgets/add_pump_dialog.dart';
import 'package:autosense_challenge_frontend/widgets/my_button.dart';
import 'package:autosense_challenge_frontend/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// A form that can be used to add or update a station
class StationsForm extends StatefulWidget {
  final Station? station;

  const StationsForm({Key? key, this.station}) : super(key: key);

  @override
  State<StationsForm> createState() => _StationsFormState();
}

class _StationsFormState extends State<StationsForm> {
  late Station station;

  @override
  void initState() {
    super.initState();
    // If station is not null, then we are updating a station
    station = widget.station != null
        ? Station(
            id: widget.station?.id,
            idName: widget.station?.idName,
            name: widget.station?.name,
            address: widget.station?.address,
            city: widget.station?.city,
            latitude: widget.station?.latitude,
            longitude: widget.station?.longitude,
            pumps: widget.station?.pumps ?? [],
          )
        : Station(
            id: null,
            idName: null,
            name: null,
            address: null,
            city: null,
            longitude: null,
            latitude: null,
            pumps: [],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station == null ? 'Add Station' : "Update Station"),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                hint: "Id Name",
                initialValue: station.idName,
                onChanged: (value) {
                  station.idName = value;
                },
              ),
              MyTextField(
                hint: "Name",
                initialValue: station.name,
                onChanged: (value) {
                  station.name = value;
                },
              ),
              MyTextField(
                hint: "Address",
                initialValue: station.address,
                onChanged: (value) {
                  station.address = value;
                },
              ),
              MyTextField(
                hint: "City",
                initialValue: station.city,
                onChanged: (value) {
                  station.city = value;
                },
              ),
              MyTextField(
                hint: "Latitude",
                initialValue:
                    station.latitude != null ? station.latitude.toString() : "",
                validator: RegExp(r'^[0-9]*\.?[0-9]*$'),
                onChanged: (value) {
                  station.latitude = double.tryParse(value);
                },
              ),
              MyTextField(
                hint: "Longitude",
                initialValue: station.longitude != null
                    ? station.longitude.toString()
                    : "",
                validator: RegExp(r'^[0-9]*\.?[0-9]*$'),
                onChanged: (value) {
                  station.longitude = double.tryParse(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pumps:",
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddPumpDialog(
                              onDone: (id, fuelType, price, available) {
                                setState(() {
                                  station.pumps.add(
                                    Pump(
                                      id: id,
                                      fuelType: fuelType,
                                      price: price,
                                      available: available,
                                    ),
                                  );
                                });
                              },
                              isUpdate: false,
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (station.pumps[index].deleted) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: station.pumps[index].available
                              ? Colors.green
                              : Colors.red,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      title: Text(
                        station.pumps[index].fuelType,
                      ),
                      subtitle: Text(
                        station.pumps[index].price.toString(),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddPumpDialog(
                                      id: station.pumps[index].id,
                                      fuelType: station.pumps[index].fuelType,
                                      price: station.pumps[index].price,
                                      available: station.pumps[index].available,
                                      isUpdate: true,
                                      onDone: (id, fuelType, price, available) {
                                        setState(() {
                                          station.pumps[index] = Pump(
                                            id: id,
                                            fuelType: fuelType,
                                            price: price,
                                            available: available,
                                          );
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  // If the pump has an id, then we want to delete
                                  // a pump from the database and thus we mark it
                                  // to delete it from the database
                                  if (station.pumps[index].id != null) {
                                    station.pumps[index].deleted = true;
                                  } else {
                                    // If the pump does not have an id, then we
                                    // want to delete a pump from the list of pumps
                                    // that hasn't been added yet to the database
                                    // so we can remove it from the list directly
                                    station.pumps.removeAt(index);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: station.pumps.length,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                widget: const Text(
                  "Save Station",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (station.idName == null ||
                      station.name == null ||
                      station.address == null ||
                      station.city == null ||
                      station.latitude == null ||
                      station.longitude == null) {
                    return;
                  }

                  if (widget.station == null) {
                    // Add station
                    BlocProvider.of<StationsBloc>(context).add(
                      CreateStation(
                        station: station,
                      ),
                    );
                  } else {
                    // Update station
                    BlocProvider.of<StationsBloc>(context).add(
                      UpdateStation(
                        station: station,
                      ),
                    );
                  }
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
