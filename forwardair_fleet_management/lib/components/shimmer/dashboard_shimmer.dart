import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:shimmer/shimmer.dart';

/*
  DashboardPage to display dashboard details.
*/
class DashBoardShimmer extends StatelessWidget {
  //Child Widgets of the Refresh Controller
  Widget _childWidgetToRefresh() {
    return _listViewWidget();
  }

  Widget _listViewWidget() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        //To display This Week filter widget
        if (index == 0) {
          return _buildThisWeekWidget();
        }
        //To display Total loads and Total Miles widget
        if (index == 1) {
          return _buildWidgetTotalLoadsAndMiles();
        }
        //To display Fuel widget
        else if (index == 2) {
          return _buildFuelWidget();
        }
        //To Display NetCompensation and Deductions Widget
        else {
          return _buildNetCompensationWidget();
        }
      },
    );
  }

  //This returns the Widget of Dashboard Page
  @override
  Widget build(BuildContext context) {
    //To fetch the data Initially

    //This returns the Dashboard Widget
    return Scaffold(
        backgroundColor: AppColors.colorDashboard_Bg,
        //BlocBuilder
        body: _childWidgetToRefresh());
  }

  //This return the This week Filter widget
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
          child: ListTile(
            trailing: SizedBox(
                width: 28,
                height: 30,
                child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      height: 36,
                      width: 36,
                      color: Colors.grey,
                    ))),
            leading: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Container(
                  height: 24,
                  width: 120,
                  color: Colors.grey,
                )),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  //This returns Holder of TotalLoadsAndMiles Widget
  _buildWidgetTotalLoadsAndMiles() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child:
          new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _totalLoadsAndMilesWidget(),
        _totalLoadsAndMilesWidget(),
      ]),
    );
  }

  //This returns TotalLoadsAndMiles Widget
  _totalLoadsAndMilesWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
        height: 80,
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            enabled: true,
                            child: Container(
                              width: 80,
                              height: 20,
                              color: Colors.grey,
                            ),
                          ))
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      height: 37,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: Container(
                          width: 80,
                          height: 20,
                          color: Colors.grey,
                        ),
                      )),
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: Container(
                        color: Colors.grey,
                        padding: EdgeInsets.only(top: 5.0),
                        height: 35,
                        width: 35,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //This returns Fuel Widget
  _buildFuelWidget() {
    return Container(
      margin: new EdgeInsets.only(top: 5, left: 10.0, bottom: 5, right: 10),
      height: 90,
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
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 5),
        child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: Container(
                        color: Colors.grey,
                        height: 20,
                        width: 120,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 27.0,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                enabled: true,
                                child: Container(
                                  color: Colors.grey,
                                  height: 20,
                                  width: 80,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                enabled: true,
                                child: Container(
                                  color: Colors.grey,
                                  height: 20,
                                  width: 80,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, right: 10, left: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 35,
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 75.0,
                              maxWidth: 100.0,
                              minHeight: 27.0,
                              maxHeight: 27.0,
                            ),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                enabled: true,
                                child: Container(
                                  color: Colors.grey,
                                  height: 20,
                                  width: 120,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                enabled: true,
                                child: Container(
                                  color: Colors.grey,
                                  height: 20,
                                  width: 120,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Column(
                        children: <Widget>[
                          Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              enabled: true,
                              child: Container(
                                height: 35,
                                width: 35,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  //This returns NetCompensationWidget Widget
  _buildNetCompensationWidget() {
    return Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10, top: 5.0, bottom: 5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 5, right: 5),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: Container(
                          color: Colors.grey,
                          height: 20,
                          width: 120,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: Container(
                            color: Colors.grey,
                            height: 20,
                            width: 120,
                          )),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: Container(
                        height: 35,
                        width: 35,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                grossCompensationAndDeductionsWiget(true),
                grossCompensationAndDeductionsWiget(false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //This returns Gross Compensation And Deductions Wiget
  Widget grossCompensationAndDeductionsWiget(bool isForGrossComp) {
    return new Container(
      child: Container(
        padding: EdgeInsets.only(
            left: 5,
            right: 10,
            top: isForGrossComp ? 30 : 10,
            bottom: isForGrossComp ? 10 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: Container(
                        color: Colors.grey,
                        height: 20,
                        width: 120,
                      )),
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: Container(
                        color: Colors.grey,
                        height: 20,
                        width: 120,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                height: 0.5,
                color: Colors.grey[400],
              ),
            )
          ],
        ),
      ),
    );
  }
}
