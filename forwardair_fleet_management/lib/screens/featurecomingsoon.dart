import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/screens/sidemenu.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

/*
  Feature coming soon page to display statics data fro Future screens.
*/
class FeaturesComingSoonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewFeatureState();
  }
}

class NewFeatureState extends State<FeaturesComingSoonPage> {

  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SafeArea(
        child: scaffoldWidget(),
      );
    } else {
      return scaffoldWidget();
    }
  }

  Widget scaffoldWidget() {
    return Scaffold(
      key: _scaffold,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        //AppBar Title
        title: TextWidget(
          text: Constants.TEXT_BACK,
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      drawer: SideMenuPage(scaffold: _scaffold,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
                height: MediaQuery.of(context).size.height * .20,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("images/img_features_coming_soon.png"),
                        fit: BoxFit.contain))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12),
            child: TextWidget(
              text: 'Features Coming Soon!',
              colorText: AppColors.colorBlack,
              textType: TextType.TEXT_MEDIUM,
              isBold: true,
            ),
          ),
          TextWidget(
            text: 'We will be notify shortly!',
            colorText: AppColors.colorBlack,
            textType: TextType.TEXT_SMALL,
          ),
        ],
      ),
    );
  }
}
