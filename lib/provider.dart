import 'package:flutter/widgets.dart';

class Provider extends StatefulWidget {
  final immutableData;
  final mutableData;
  final child;

  const Provider({this.immutableData, this.mutableData, this.child});

  static immutableDataOf(BuildContext context) {
    _InheritedProvider p = inheritedProvider(context);
    return p.immutableData;
  }

  static mutableDataOf(BuildContext context) {
    _InheritedProvider p = inheritedProvider(context);
    return p.mutableData;
  }

  static _InheritedProvider inheritedProvider(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_InheritedProvider);

  @override
  State<StatefulWidget> createState() => new _ProviderState();
}

class _ProviderState extends State<Provider> {
  @override
  initState() {
    super.initState();
    widget.mutableData.addListener(didValueChange);
  }

  didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      immutableData: widget.immutableData,
      mutableData: widget.mutableData,
      child: widget.child,
    );
  }

  @override
  dispose() {
    widget.mutableData.removeListener(didValueChange);
    super.dispose();
  }
}

class _InheritedProvider extends InheritedWidget {
  final immutableData;
  final mutableData;
  final child;
  final _dataValue;

  _InheritedProvider({this.immutableData, this.mutableData, this.child})
      : _dataValue = mutableData.value,
        super(child: child);

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _dataValue != oldWidget._dataValue;
  }
}
