import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:shimmer/shimmer.dart';

class SettlementShimmerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }

  //This is the main widget for this page
  Widget _mainWidget() {
    return Scaffold(
        body: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[_buildThisWeekWidget(), _listViewWidget()]));
  }

  Widget _listViewWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItemsWidget();
      },
    );
  }

  _buildListItemsWidget() {
    return Container(
      margin: new EdgeInsets.only(top: 5, left: 10.0, bottom: 5, right: 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Shimmer.fromColors(
                  period: Duration(milliseconds: 800),
                  baseColor: Colors.grey[400],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Container(
                    width: 80,
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
                Shimmer.fromColors(
                  period: Duration(milliseconds: 800),
                  baseColor: Colors.grey[400],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Container(
                    width: 80,
                    height: 20,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 0.5,
          ),
          Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Shimmer.fromColors(
                    period: Duration(milliseconds: 800),
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      width: 80,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5),),
                  Shimmer.fromColors(
                    period: Duration(milliseconds: 800),
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      width: 80,
                      height: 20,
                      color: Colors.grey,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  _buildThisWeekWidget() {
    return Container(
      height: 50,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      margin: new EdgeInsets.only(top: 10, left: 10.0, bottom: 5, right: 10),
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Shimmer.fromColors(
                    period: Duration(milliseconds: 800),
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      height: 28,
                      width: 120,
                      color: Colors.grey,
                    )),
                Shimmer.fromColors(
                    period: Duration(milliseconds: 800),
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      height: 28,
                      width: 40,
                      color: Colors.grey,
                    )),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
