import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';



class ListViewShimmer extends StatelessWidget {
  final int listLength;

  const ListViewShimmer({Key key,this.listLength}): super(key: key);

  @override
  Widget build(BuildContext context) {
    int len=(this.listLength!=0)?this.listLength:5;
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics (),
        shrinkWrap: true,
        itemCount: len,
        itemBuilder: (BuildContext context, int index) {
          return displayDemo();
        },
      ),
    );
  }
  Widget displayDemo(){
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric( vertical: 8.0),
        child: Column(
          children: <Widget>[
            Shimmer.fromColors(
              period: Duration(milliseconds: 1000),
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    width: 40.0,
                    height: 12.0,
                    color: Colors.white,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 40),
                    width: double.infinity,
                    height: 12.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 40),
                    width: double.infinity,
                    height: 12.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    width: 120.0,
                    height: 12.0,
                    color: Colors.white,
                  ),
                ],
              ),

              ),

          ],
        ),
      ),
    );
  }
}