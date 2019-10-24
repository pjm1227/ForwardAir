import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';


//This class is used to call API for view history inside safety and incidents module
class ViewHistoryPage extends StatelessWidget {
 //final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Returns a Scaffold
    if (Platform.isAndroid) {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    } else {
      return _scaffoldWidget();
    }
  }

  //It's the main widget for view history
  Widget _scaffoldWidget() {
    return Scaffold(
       // key: _scaffold,
//        appBar: new AppBar(
//          iconTheme: new IconThemeData(color: Colors.white),
//          centerTitle: false,
//          //AppBar Title
//          title: TextWidget(
//            text: 'Safety & Incident History',
//            colorText: AppColors.colorWhite,
//            textType: TextType.TEXT_LARGE,
//          ),
//        ),
//        drawer: SideMenuPage(
//          scaffold: _scaffold,
//        ),
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return _listItem();
            }));
  }

  Widget _listItem() {
    //this card widget will contain all the information regarding breakdown
    return Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Row widget to show the card title text
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextWidget(
                    text: "Breakdown",
                    colorText: AppColors.colorAppBar,
                    textType: TextType.TEXT_SMALL,
                    textAlign: TextAlign.start,
                    isBold: true,
                  )),
                ],
              ),
            ),

            // this widget to show breakdown description
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextWidget(
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vel dui sem.Aliquam ut interdum lectus.Pallentesque ut finibus ipsum',
                colorText: AppColors.colorBlack,
              ),
            ),

            //this widget is for location text
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                      width: 12,
                      height: 12,
                      child: Image.asset('images/ic_location.png')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16, right: 8, bottom: 8),
                      child: TextWidget(
                          text: 'Location xyz,LA,USA,33234 ',
                          colorText: AppColors.colorGrey,
                          isBold: true,
                          textAlign: TextAlign.start),
                    ),
                  ),
                ],
              ),
            ),
            //this widget is for text showing date
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                      width: 12,
                      height: 12,
                      child: Image.asset('images/ic_date.png')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 8, bottom: 8),
                      child: TextWidget(
                          text: '12 June 11.34 AM ',
                          colorText: AppColors.colorGrey,
                          isBold: true,
                          textAlign: TextAlign.start),
                    ),
                  ),
                ],
              ),
            ),
            //this widget is for the text reported by
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                      width: 12,
                      height: 12,
                      child: Image.asset('images/ic_reportedby.png')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 8, bottom: 8),
                      child: TextWidget(
                          text: 'Reported by User Name - TRID7500 ',
                          colorText: AppColors.colorGrey,
                          isBold: true,
                          textAlign: TextAlign.start),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
