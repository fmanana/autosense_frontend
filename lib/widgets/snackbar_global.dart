import 'package:flutter/material.dart';

class SnackbarGlobal {
  // This is the key that will be used to access the scaffold messenger
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
