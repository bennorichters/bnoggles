import 'package:bnoggles/screens/start/widgets/settings.dart';
import 'package:bnoggles/utils/configuration.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  final Configuration configuration;

  StartScreen({Key key, @required this.configuration}) : super(key: key);

  @override
  State createState() => StartScreenState(configuration: configuration);
}

class StartScreenState extends State<StartScreen> {
  final Configuration configuration;

  StartScreenState({@required this.configuration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
      ),
      body: Center(
        child: Container(
          width: 500.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SettingsGrid(
                configuration.preferences.time,
                configuration.preferences.size,
                configuration.preferences.length,
              ),
              Center(
                child: StartGameButton(configuration: configuration),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
