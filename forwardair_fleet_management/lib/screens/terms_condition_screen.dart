import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forwardair_fleet_management/blocs/events/terms_events.dart';
import 'package:forwardair_fleet_management/blocs/states/terms_state.dart';
import 'package:forwardair_fleet_management/blocs/terms_condition_bloc.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/screens/drawermenu.dart';

import '../main.dart';
import 'login_screen.dart';

/*class TermsConditions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TermsPage();
  }
}*/

class TermsConditions extends StatelessWidget {
  //This variable is used for checkbox state
  var isChecked = false;

  //TermsBloc
  final TermsBloc _termsBloc = new TermsBloc();

  @override
  Widget build(BuildContext context) {
    //For status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // status bar color
    ));
    //It returns BlocBuilder, That means it will refresh itself and which we're passing
    //TermsBloc and Terms State, State is using to manage or replace widgets.
    return Scaffold(
      body: BlocListener<TermsBloc, TermsStates>(
        bloc: _termsBloc,
        listener: (context, state) {
          if (state is CheckBoxState) {
            isChecked = state.accepted;
          }
          if (state is AcceptState) {
            if (!state.accepted) {
              Utils.showSnackBar(Constants.ACCEPT_TERMS_CONDITION, context);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            }
          }
        },
        child: BlocBuilder<TermsBloc, TermsStates>(
            bloc: _termsBloc,
            builder: (context, state) {
              print('Terms Page $state');
              if (state is DeclineState) {
                return DrivingConfirmation();
              }
              return _initialWidget(context);
            }),
      ),
    );
  }

  //Initial widget to show user
  Widget _initialWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Container for showing image
          Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'images/ic_fa_logo.png',
              ),
            ),
          ),
          //Text widget for Text of terms of service
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Constants.TERMS_SERVICE,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          //Text widget for text of terms and conditions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Constants.TERMS_AND_CONDITIONS,
            ),
          ),
          //Divider
          Divider(
            color: Colors.grey,
            height: 1.0,
          ),
          //Checkbox Widget
          _checkBoxWidget(),
          _buttonsWidget(context),
        ],
      ),
    );
  }

  //Checkbox widget
  Widget _checkBoxWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: isChecked,
            activeColor: AppColors.colorRed,
            onChanged: (value) {
              /*setState(() {
                isChecked = value;
              });*/
              //isChecked = value;
              _termsBloc.dispatch(CheckBoxEvent(isChecked: value));
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                Constants.CHECKBOX_TEXT,
                style: TextStyle(
                  fontFamily: Constants.FONT_FAMILY_ROBOTO_MEDIUM,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //This method return buttons to accept and decline the terms and conditions.
  Widget _buttonsWidget(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              decoration:
                  BoxDecoration(border: Border.all(color: AppColors.colorRed)),
              child: ButtonWidget(
                onPressed: () => _termsBloc.dispatch(DeclineEvent()),
                text: Constants.TEXT_DECLINE,
                fontSize: 16,
                colorText: AppColors.colorRed,
                colorButton: AppColors.colorWhite,
              ),
            ),
//
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              child: ButtonWidget(
                onPressed: () =>
                    _termsBloc.dispatch(AcceptEvent(isChecked: isChecked)),
                text: Constants.TEXT_ACCEPT,
                fontSize: 16,
              ),
            )
          ],
        ));
  }
}
