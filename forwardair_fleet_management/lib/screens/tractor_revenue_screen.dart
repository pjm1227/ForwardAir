import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/revenue.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/list_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

class TractorRevenueDetails extends StatefulWidget {
  final String transactionType;
  final int oid;

  const TractorRevenueDetails({Key key, this.transactionType, this.oid})
      : super(key: key);

  @override
  _TractorRevenueDetailsState createState() =>
      _TractorRevenueDetailsState(transactionType, oid);
}

class _TractorRevenueDetailsState extends State<TractorRevenueDetails> {
  final String transactionType;
  final int oid;

  //Bloc object
  RevenueDetailsBloc _revenueDetailsBloc = RevenueDetailsBloc();

  _TractorRevenueDetailsState(this.transactionType, this.oid);

  @override
  void initState() {
    //Make  API Call here to fetch revenue details
    _revenueDetailsBloc.dispatch(
        FetchRevenueDetailsEvent(transactionType: transactionType, oid: oid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SafeArea(child: _initialWidget());
    } else {
      return _initialWidget();
    }
  }

  Widget _initialWidget() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        title: TextWidget(
          text: 'Rvenue Details',
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      body: BlocListener<RevenueDetailsBloc, RevenueDetailsState>(
        listener: (context, state) {},
        bloc: _revenueDetailsBloc,
        child: BlocBuilder<RevenueDetailsBloc, RevenueDetailsState>(
          bloc: _revenueDetailsBloc,
          builder: (context, state) {
            if (state is RevenueErrorState) {
              if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                return NoInternetFoundWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
            //If state is success then show data in list
            if (state is RevenueSuccessState) {
              if (state.tractorRevenueModel != null) {
                return _mainWidget(state.tractorRevenueModel);
              } else {
                return NoResultFoundWidget();
              }
            }
            return ListViewShimmer(
              listLength: 10,
            );
          },
        ),
      ),
    );
  }

  //This widget is used to set data in widgets
  Widget _mainWidget(TractorRevenueModel tractorRevenueModel) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TextWidget(text: 'dbfdksfbdkfbdksfkdsfdkfbirubfdbihb',)
            ],
          )
        ],
      ),
    );
  }
}
