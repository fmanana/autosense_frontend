import 'package:autosense_challenge_frontend/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

// A dialog that can be used to add or edit a pump
class AddPumpDialog extends StatefulWidget {
  final int? id;
  final String? fuelType;
  final double? price;
  final bool? available;
  final void Function(
          int? id, String fuelType, double price, bool available)
      onDone;
  final bool isUpdate;

  const AddPumpDialog({
    Key? key,
    this.id,
    this.fuelType,
    this.price,
    this.available,
    required this.onDone,
    required this.isUpdate,
  }) : super(key: key);

  @override
  State<AddPumpDialog> createState() => _AddPumpDialogState();
}

class _AddPumpDialogState extends State<AddPumpDialog> {
  String idName = "";
  String fuelType = "";
  double? price;
  bool available = true;

  @override
  void initState() {
    super.initState();
    // If the dialog is used to edit a pump, the initial values are set
    fuelType = widget.fuelType ?? "";
    price = widget.price;
    available = widget.available ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      title: Text(
        widget.isUpdate ? "Update Pump": "Add Pump",
        style: Theme.of(context).textTheme.displaySmall!.merge(
              TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
              initialValue: fuelType,
              hint: "Fuel Type",
              onChanged: (value) {
                fuelType = value;
              },
              enabled: !widget.isUpdate,
          ),
          MyTextField(
              initialValue: price != null ? price.toString() : "",
              hint: "Price",
              validator: RegExp(r'^[0-9]*\.?[0-9]*$'),
              onChanged: (value) {
                price = double.tryParse(value);
              }),
          Row(
            children: [
              Checkbox(
                value: available,
                onChanged: (bool? value) {
                  setState(() {
                    available = value!;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              const Text("Available"),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "Done",
            style: Theme.of(context).textTheme.headlineSmall!.merge(
                  TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          ),
          onPressed: () {
            // Validate the form and only if valid call the onDone callback
            if (fuelType.isEmpty || price == null) return;
            widget.onDone(widget.id, fuelType, price!, available);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.headlineSmall!.merge(
                  TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
