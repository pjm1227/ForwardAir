import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/drill_down_bloc.dart';
import 'package:forwardair_fleet_management/blocs/events/drill_down_event.dart';
import 'package:forwardair_fleet_management/blocs/states/drill_down_state.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/drillDown/drill_down_model.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/screens/load_detail.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class LoadsPage extends StatefulWidget {
  final bool isMilePage;
  final Dashboard_DB_Model dashboardData;

  LoadsPage( this.isMilePage,this.dashboardData);
  @override
  _LoadsPageState createState() => _LoadsPageState(this.isMilePage,this.dashboardData);
}

class _LoadsPageState extends State<LoadsPage> {

    bool isMilePage;  //carried out from dashboard to check whether it is drilldown of load/mile
   Dashboard_DB_Model dashboardData;  //dashboard data carried out from dashboard for passing the specific period to the url
   _LoadsPageState(this.isMilePage,this.dashboardData);

  Map<String, double> dataMap = new Map();  //this variable for mapping the data to the chart
  DrillDownBloc _drillDowndBloc = DrillDownBloc();  //this is for bloc where we are doing logical operation
  DrillDownModel drillData;  //this variable will be intialized for the first time which is being constant
  String emptyPercentage; // this is for showing the empty percentage in top bar
  String loadPercent;  // this is for showing the load percentage in top bar
  double otherCon;   // this variable assigned for the sum of the other contributor other than top contributors
  String filterText='';  //this will be the text in place of sort by after selecting the filter option
   //this will return true or false ,if true the miles data will be displayed otherwise loads data will be displayed
  List<Tractors> othersData;  // this is constant for other contributors
  List<Tractors> topContributor; // this is constant for top contributors
   List<Tractors> others; // this will be changed based on sorting  for other contributors
   List<Tractors> top;  // this will be changed based on sorting  for top contributors

  //color list which is used in pie chart
  List<Color> colorList = [
    Color.fromRGBO(227, 26, 28, 1),
    Color.fromRGBO(51, 160, 44, 1),
    Color.fromRGBO(31, 120, 180, 1),
    Color.fromRGBO(251, 154, 153, 1),
    Color.fromRGBO(255, 127, 0, 1),
    Color.fromRGBO(166, 206, 227, 1),
    Color.fromRGBO(178, 223, 138, 1),
    Color.fromRGBO(253, 191, 111, 1),
  ];

  @override
  Widget build(BuildContext context) {

    TextStyle _boldStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: Colors.grey,
        fontWeight: FontWeight.w700);
    TextStyle _appBarboldStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600);
    Color topWidgetColor = Color.fromRGBO(15, 43, 52, 1);
    Color pageBgColor = Color.fromRGBO(246, 246, 246, 1);

    if(dashboardData.weekStart!=null) {
      _drillDowndBloc.dispatch(
          FetchDrillDownEvent(weekStart: dashboardData.weekStart,
              weekEnd: dashboardData.weekEnd, month: 0, year: "",isMilePage: this.isMilePage));
    }
    else{
      _drillDowndBloc.dispatch(
          FetchDrillDownEvent(weekStart: dashboardData.weekStart,
              weekEnd: dashboardData.weekEnd, month: dashboardData.month, year: dashboardData.year,isMilePage: this.isMilePage));
    }


    return new Scaffold(
      backgroundColor: AppColors.colorDashboard_Bg,
      body: BlocBuilder<DrillDownBloc, dynamic>(
        bloc:_drillDowndBloc ,
        builder: (context, state) {


            if (state is DrillDataError ) {
            return Center(
              child: Text('Failed to fetch details'),
            );
          } else if (state is DrillDataLoaded) {

//            _refreshController.refreshCompleted();
            print('Entering to the UI part');
            if (state.drillDownData != null) {
              drillData=state.drillDownData;

              getTopContributor();
              getLoadedEmptyPercent();

            }

        //by default view with data sorted based on contribution
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: topWidgetColor,
                  centerTitle: false,
                  leading: InkWell(
                    child: Icon(Icons.arrow_back,color: Colors.white,),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(isMilePage ?'Miles':'Loads',style: _appBarboldStyle,),
                ),
                backgroundColor: pageBgColor,
                body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    // The containers in the background
                    new Column(
                      children: <Widget>[
                        //Top Widget
                        new Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            color: topWidgetColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[_rectangleWidget()],
                            )),
                        //Bottom Widget
                        Container(
                          color: pageBgColor,
                          margin: EdgeInsets.only(left: 20, right: 10,top: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Top Contributors", style: _boldStyle),
                                filterWidget(),
                              ]),
                        ),
                        _bottomListViewWidget(topContributor),

                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                              child: Text(
                                'Others',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        _bottomListViewWidget(othersData)
                      ],
                    ),
                    new Container(
                      alignment: Alignment.topCenter,
                      padding: new EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .2,
                          right: 10.0,
                          left: 10.0),
                      child: Container(
                        height: 250.0,
                        width: MediaQuery.of(context).size.width,
                        child: _pieChartWidget(),
                      ),
                    )
                  ],
                ),
                ));

            }
            else if(state is SortedState){
              if (state.sortedData != null) {
                print('Entering with sorted Data');
                getTopTen(state.sortedData);
                getLoadedEmptyPercent();

              }
           //view after sorting data keeping chart data constant
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: topWidgetColor,
                    centerTitle: false,
                    leading: InkWell(
                      child: Icon(Icons.arrow_back,color: Colors.white,),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text(isMilePage ?'Miles':'Loads',style: _appBarboldStyle,),
                  ),
                  backgroundColor: pageBgColor,
                  body: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        // The containers in the background
                        new Column(
                          children: <Widget>[
                            //Top Widget
                            new Container(
                                height: MediaQuery.of(context).size.height * 0.7,
                                color: topWidgetColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[_rectangleWidget()],
                                )),
                            //Bottom Widget
                            Container(
                              color: pageBgColor,
                              margin: EdgeInsets.only(left: 20, right: 10,top: 5),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Top Contributors", style: _boldStyle),
                                    filterWidget(),
                                  ]),
                            ),
                            _bottomListViewWidget(top),

                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                                  child: Text(
                                    'Others',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            _bottomListViewWidget(others)
                          ],
                        ),
                        new Container(
                          alignment: Alignment.topCenter,
                          padding: new EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .2,
                              right: 10.0,
                              left: 10.0),
                          child: Container(
                            height: 250.0,
                            width: MediaQuery.of(context).size.width,
                            child: _pieChartWidget(),
                          ),
                        )
                      ],
                    ),
                  ));


            }
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),

    );

  }

  //creating widget for filter
  Widget filterWidget(){
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 30,
      width: 120,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child:Column(children: <Widget>[
              Row(children: [
                Expanded(
                  flex: 2,
                  child: Text(filterText==''?'Sort By':filterText,
                      style: TextStyle(
                          fontFamily: Constants.FONT_FAMILY_ROBOTO,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black)),
                ),
                Expanded(
                    flex: 1,
                    child:Icon(Icons.arrow_drop_down))
              ]),
              Divider(height: 1,color: Colors.grey,)
            ],),
            onTap: () {
              _filterModalBottomSheet(context);
            },
            ),

          ),

      );
  }

  //Top Widget to show total,empty and loaded
  Widget _rectangleWidget() {
    TextStyle _boldStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold);
    TextStyle _normalStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    );

    return new Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 20),
        height: 220.0,
        child: Column(
          children: <Widget>[


               Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(dashboardData.weekStart!=null ? 'This Week' : 'This Month',style: TextStyle(color: Colors.white,fontSize: 14),),
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                height: 2,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  height: 12.0,
                                  width: 12.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Text(
                                  isMilePage ? '${dashboardData.totalMiles}' : '${dashboardData.totalLoads}',
                                  style: _boldStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'TOTAL',
                            textAlign: TextAlign.right,
                            style: _normalStyle,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left:15,right: 15),
                            child:Container(
                              height:MediaQuery.of(context).size.height * 0.08 ,
                              child: VerticalDivider(
                                width: 4,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  color: Color.fromRGBO(227, 26, 28, 1),
                                  height: 12.0,
                                  width: 12.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                 '${emptyPercentage}%',
                                  style: _boldStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text('EMPTY',
                              textAlign: TextAlign.center, style: _normalStyle),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left:15,right: 15),
                            child:Container(
                              height:MediaQuery.of(context).size.height * 0.08 ,
                              child: VerticalDivider(
                                width: 4,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  color: Color.fromRGBO(45, 135, 151, 1),
                                  height: 12.0,
                                  width: 12.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                 '${loadPercent}%',
                                  style: _boldStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text('LOADED',
                              textAlign: TextAlign.center, style: _normalStyle),
                        ),
                      ],
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                height: 2,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  //widget which handles the pue_chart as well as data
  Widget _pieChartWidget() {

    //this iteration for top 10 contributor
    for(int i=0;i<topContributor.length;i++){
      if(isMilePage)
      dataMap.putIfAbsent("${topContributor[i].tractorId}", () => topContributor[i].totalMilesPercent);
      else
        dataMap.putIfAbsent("${topContributor[i].tractorId}", () => topContributor[i].totalLoadsPercent);
    }
    dataMap.putIfAbsent("Others", () => otherCon);   //this is the sum of other contributor
    return PieChart(
      dataMap: dataMap,
      chartValuesColor: Colors.transparent,
      animationDuration: Duration(milliseconds: 600),
      chartLegendSpacing: 0.0,
      chartRadius: MediaQuery.of(context).size.width / 2,
      showChartValuesInPercentage: false,
      showChartValues: false,
      showChartValuesOutside: false,
      colorList: colorList,
      showLegends: false,
      decimalPlaces: 0,
    );
  }

  //widget for dropdown
  Widget dropDown(BuildContext context) {
    String dropdownValue = 'Sort By';
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Sort By', 'Contribution: High to Low', 'Ascending Tractor Id', 'Descending Tractor Id']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

  }

  //ListView widget
  Widget _bottomListViewWidget(List<Tractors> modelData) {


    final _fontStyle = TextStyle(
        fontSize: 18.0,
        color: Colors.black54,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: modelData.length,
      itemBuilder: (context, index) {
        var post = modelData[index];

        return InkWell(
          onTap: () =>
            navigateToLoadDetailPage(post),
          child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Card(
                child: Container(
                  height: 70,
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: ClipOval(
                            child: Container(
                              color: Color.fromRGBO(140, 234, 255, 1),
                              height: 12.0,
                              width: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Tractor ID:",
                                  style: _fontStyle,
                                ),
                                Text(
                                  '${modelData[index].tractorId}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, bottom: 5, top: 5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Contribution(%):',
                                  style: _fontStyle,
                                ),
                                Text(
                                  isMilePage? '${modelData[index].totalMilesPercent}' : '${modelData[index].totalLoadsPercent}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                          color: Color.fromRGBO(45, 135, 151, 1),
                          child: Center(
                              child: Text(
                                isMilePage? '${modelData[index].totalMiles}' : '${modelData[index].totalLoads}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              )),
                        )),
                  ]),
                )),
              ),

        );
      },
    );
  }

  Widget _sortFilterWidget(String title) {
    final _textStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: Constants.FONT_FAMILY_ROBOTO,
      fontSize: 16,
      color: Colors.black,
    );
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: new Text(title, style: _textStyle),
    );
  }

  Widget _filterModalBottomSheet(context) {
    //To Align a Text
    final centerTextAlign = TextAlign.center;
    //List of options in filter bootom sheet
    final weekFilterOptions = [
      Constants.TEXT_HIGHTOLOW,
      Constants.TEXT_LOWTOHIGH,
      Constants.TEXT_ASCENDING,
      Constants.TEXT_DESCENDING,


    ];
    //Text Style of the Cancel Text
    final _cancelText = Text(
      Constants.TEXT_CANCEL,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 16,
        color: AppColors.colorRed,
      ),
      textAlign: centerTextAlign,
    );
    //This Returns bottom sheet
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 240,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: weekFilterOptions.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 44,
                    child: ListTile(
                      title: index != 4
                          ? _sortFilterWidget(weekFilterOptions[index])
                          : _cancelText,
                      onTap: () {
                        if (index == 4) {
                          Navigator.of(context).pop();
                        } else {

                  _drillDowndBloc.dispatch(
                      FilterEvent(filterOption: weekFilterOptions[index],drillData: drillData,isMilePage: this.isMilePage));
                        Navigator.of(context).pop();

                        }
                      },
                    ),
                  );
                },
              ));
        });
  }



 /*dividing the data in two parts based on contribution i.e top 10 and others for chart
    it is constant which does not change */
  getTopContributor(){
    othersData=new List();
    topContributor=new List();
    otherCon=0;
    for(int i=0;i<drillData.tractors.length;i++){
      if(i<10)
        topContributor.add(drillData.tractors[i]);
      else{
        othersData.add(drillData.tractors[i]);
        if (isMilePage)
          otherCon= otherCon + drillData.tractors[i].totalMilesPercent;
        else
          otherCon = otherCon + drillData.tractors[i].totalLoadsPercent;
      }
    }


  }

   @override
   void dispose() {
     _drillDowndBloc.dispose();
     super.dispose();
   }

  //diving the data in two categories top 10 and others for listView
  getTopTen(DrillDownModel data){
    double otherCon=0.0;
    others=new List();
    top=new List();
    for(int i=0;i<data.tractors.length;i++){
      if(i<10)
          top.add(data.tractors[i]);
      else {
        others.add(data.tractors[i]);
      }
    }
    return otherCon;
  }

  //empty and load percentage for top rows
   getLoadedEmptyPercent(){
    emptyPercentage="";
    loadPercent="";
     if(isMilePage) {
       emptyPercentage = ((dashboardData.emptyMiles * 100) / dashboardData.totalMiles).toStringAsFixed(2);
       loadPercent = ((dashboardData.loadedMiles * 100) / dashboardData.totalMiles).toStringAsFixed(2);
     }
     else{
       emptyPercentage = ((dashboardData.emptyLoads* 100) / dashboardData.totalLoads).toStringAsFixed(2);
       loadPercent = ((dashboardData.loadedLoads* 100) / dashboardData.totalLoads).toStringAsFixed(2);
     }
   }

   void navigateToLoadDetailPage(Tractors tractorData) {
     _drillDowndBloc.dispose();
//     Navigator.push(
//         context,
//         PageTransition(
//             type: PageTransitionType.fade, child: LoadDetailsPage(this.isMilePage,tractorData,this.dashboardData)));
   }
}
