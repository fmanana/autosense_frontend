import 'package:autosense_challenge_frontend/blocs/stations/stations_bloc.dart';
import 'package:autosense_challenge_frontend/pages/map_page.dart';
import 'package:autosense_challenge_frontend/widgets/snackbar_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    // BlocProvider is used to provide the bloc to the widget tree
    BlocProvider<StationsBloc>(
      create: (context) => StationsBloc(),
      child: BlocListener<StationsBloc, StationsState>(
        listener: (context, state) {
          if (state is StationsError) {
            SnackbarGlobal.show(
              state.message,
            );
          }
        },
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autosense Challenge - Gas Stations',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: SnackbarGlobal.key,
      debugShowCheckedModeBanner: false,
      home: const MapPage(),
    );
  }
}
