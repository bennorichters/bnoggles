import 'package:bnoggles/screens/settings/widgets/settings.dart';
import 'package:bnoggles/utils/configuration.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Configuration configuration;

  SettingsScreen({Key key, @required this.configuration}) : super(key: key);

  @override
  State createState() => SettingsScreenState(configuration: configuration);
}

class SettingsScreenState extends State<SettingsScreen> {
  final Configuration configuration;

  SettingsScreenState({@required this.configuration});

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
                configuration.preferences
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
