import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../revenue_item_widget.dart';
import '../text_widget.dart';

/*
  Revenue Details Shimmer to display revenue details.
*/
class RevenueDetailsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Shimmer.fromColors(
          period: Duration(milliseconds: 1000),
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 80.0,
                  color: Colors.white,
                )
              ],
            )));
  }

}
