import 'package:autosense_challenge_frontend/blocs/stations/stations_bloc.dart';
import 'package:autosense_challenge_frontend/models/station_model.dart';
import 'package:autosense_challenge_frontend/pages/stations_form.dart';
import 'package:autosense_challenge_frontend/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This page is used to display the details of a gas station
// It also has buttons to edit or delete the gas station
class DetailsPage extends StatefulWidget {
  final Station station;

  const DetailsPage({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Yes button for the alert box for confirming the deletion of a gas station
    Widget yesButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed: () {
        BlocProvider.of<StationsBloc>(context).add(
          DeleteStation(station: widget.station),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // No button for the alert box for confirming the deletion of a gas station
    Widget noButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // The alert box for confirming the deletion of a gas station
    AlertDialog deleteAlert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: const Text(
        "Warning",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: const Text(
        "Are you sure that you want to delete this station?",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name!),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.station.name!,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              "${widget.station.address!}, ${widget.station.city!}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Latitude: ${widget.station.latitude}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Longitude: ${widget.station.longitude}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Pumps:",
              style: TextStyle(fontSize: 18),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    // add grey border
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: widget.station.pumps[index].available
                              ? Colors.green
                              : Colors.red,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        )),
                    title: Text(
                      widget.station.pumps[index].fuelType,
                    ),
                    subtitle: Text(
                      widget.station.pumps[index].price.toString(),
                    ),
                    trailing: Text(
                      widget.station.pumps[index].available
                          ? "Available"
                          : "Not Available",
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: widget.station.pumps.length,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: MyButton(
                    widget: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    color: Colors.green[300]!,
                    onPressed: () {
                      // Navigate to the form page to edit the gas station
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StationsForm(
                            station: widget.station,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: MyButton(
                    widget: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    color: Colors.red[300]!,
                    onPressed: () {
                      // Show the alert box to confirm the deletion of the gas station
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return deleteAlert;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: 200,
                  child: MyButton(
                    widget: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    color: Colors.blue[300]!,
                    onPressed: () {
                      // Navigate back to the map page
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
