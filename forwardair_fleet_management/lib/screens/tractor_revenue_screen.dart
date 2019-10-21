import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/revenue.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/revenue_item_widget.dart';
import 'package:forwardair_fleet_management/components/shimmer/revenue_page_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

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
          text: 'Revenue Details',
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
            return RevenueDetailsShimmer();
          },
        ),
      ),
    );
  }

  //This widget is used to set data in widgets
  Widget _mainWidget(dynamic data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Card(
            child: data is TractorRevenueModel
                ? _earningWidget(data)
                : _deductionWidget(data)),
      ),
    );
  }

  Widget _earningWidget(TractorRevenueModel data) {
    return Column(
      children: <Widget>[
        RevenueItemWidget(
            tagName: 'Tractor ID', tagValue: data.tractorId.toString()),
        RevenueItemWidget(
            tagName: 'Date',
            tagValue: Utils.formatDateFromString(data.transactionDt)),
        RevenueItemWidget(tagName: 'Amount', tagValue: '\$${data.amount}'),
        RevenueItemWidget(tagName: 'Order #', tagValue: data.orderNbr),
        RevenueItemWidget(tagName: 'Driver', tagValue: data.driver1First),
        RevenueItemWidget(tagName: 'Origin', tagValue: data.originCty),
        RevenueItemWidget(
            tagName: 'Origin Date',
            tagValue: Utils.formatDateFromString(data.originDt.toString())),
        RevenueItemWidget(tagName: 'Destination', tagValue: data.destCty),
        RevenueItemWidget(
            tagName: 'Destination Date',
            tagValue: Utils.formatDateFromString(data.destDt)),
        RevenueItemWidget(
            tagName: 'Loaded Miles', tagValue: data.loadedMiles.toString()),
        RevenueItemWidget(
            tagName: 'Empty Miles', tagValue: data.emptyMiles.toString()),
        RevenueItemWidget(tagName: 'Quantity', tagValue: data.qty.toString()),
        RevenueItemWidget(tagName: 'Rate', tagValue: data.rate.toString()),
        RevenueItemWidget(tagName: 'UOM', tagValue: data.uom),
        RevenueItemWidget(tagName: 'Taxable', tagValue: data.taxableFlg),
        _descriptionWidget(data.description, data.comment)
      ],
    );
  }

  Widget _deductionWidget(RevenueDeductionModel data) {
    return Column(
      children: <Widget>[
        RevenueItemWidget(
            tagName: 'Tractor Id', tagValue: data.tractorId.toString()),
        RevenueItemWidget(
            tagName: 'Date',
            tagValue: Utils.formatDateFromString(data.transactionDt)),
        RevenueItemWidget(tagName: 'Deduction Type', tagValue: data.category),
        RevenueItemWidget(
            tagName: 'Driver Contribution',
            tagValue: '\$${data.drivercontribution}'),
        RevenueItemWidget(
            tagName: 'Original Balance', tagValue: '${Utils.addDollarAfterMinusSign(data.originalbalance)}'),
        RevenueItemWidget(
            tagName: 'Driver Owing', tagValue: '\$${data.driverowing}'),
        RevenueItemWidget(
            tagName: 'Service Charge', tagValue: '\$${data.servicecharge}'),
        RevenueItemWidget(tagName: 'Payment', tagValue: '${Utils.addDollarAfterMinusSign(data.payment)}'),
        _descriptionWidget(data.description, 'N/A')
      ],
    );
  }

  //This is the common widget for deduction and earning widgets,
  //In this widget we're showing comments and description
  Widget _descriptionWidget(String description, String comment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(text: 'Description'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(
              text: description,
              colorText: AppColors.colorAppBar,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(text: 'Comments'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: TextWidget(
              text: comment,
              colorText: AppColors.colorAppBar,
            ),
          )
        ],
      ),
    );
  }
}
