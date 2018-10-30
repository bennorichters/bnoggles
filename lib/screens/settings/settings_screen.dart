import 'package:bnoggles/screens/settings/widgets/settings.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Preferences preferences;

  SettingsScreen({Key key, @required this.preferences}) : super(key: key);

  @override
  State createState() => SettingsScreenState(preferences: preferences);
}

class SettingsScreenState extends State<SettingsScreen> {
  final Preferences preferences;

  SettingsScreenState({@required this.preferences});

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
                preferences
              ),
              Center(
                child: StartGameButton(parameterProvider: preferences.toParameters),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
