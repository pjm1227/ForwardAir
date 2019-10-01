import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class RoundShimmer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[100],
        enabled: true,
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 80,color: Colors.white),
            ),
            ClipOval(
            child: Container(
              color: Colors.white,
              height: 180,
              width: 180,
            ),
      ),
          ],
        ),
      ));
  }

}