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
          period: Duration(milliseconds: 800),
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

  //This is the common widget for deduction and earning widgets,
  //In this widget we're showing comments and description
  Widget _descriptionWidget(String description, String comment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(text: 'Description'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(
              text: description,
              colorText: AppColors.colorAppBar,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(text: 'Comments'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(
              text: comment,
              colorText: AppColors.colorAppBar,
            ),
          )
        ],
      ),
    );
  }
}
