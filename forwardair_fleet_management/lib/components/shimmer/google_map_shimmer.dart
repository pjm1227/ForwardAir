import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MapShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                width: double.infinity,
                height: 40.0,
                color: Colors.white,
              ),

            ]
        ),
      ),
    );
  }
  }