import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/drillDown/drill_down_model.dart';

class ListViewWidget extends StatelessWidget {
  final List<Tractors> tractorData;

  ///On Pressed Event
  final GestureTapCallback onPressed;

  const ListViewWidget({Key key, @required this.tractorData, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
