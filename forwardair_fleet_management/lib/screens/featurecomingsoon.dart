import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final _appBarStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white);
    TextStyle styleRC = TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black);
    TextStyle substyleRC = TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black);

    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        title: new Text(
          "Back",
          style: _appBarStyle,
        ),
        backgroundColor: Color.fromRGBO(15, 43, 52, 1),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Center(
            child: Container(
              // color: Colors.greenAccent,
                height: MediaQuery.of(context).size.height * .35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/img_features_coming_soon.png"),
                        fit: BoxFit.contain))
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:12.0, bottom: 12),
            child: Text('Features Coming Soon!',style: styleRC),
          ),
          Text('We will be notify shortly!',style: substyleRC),
        ],
      ),
    );
  }
}
