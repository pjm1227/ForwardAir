import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/shimmer/round_simmer.dart';

import 'list_shimmer.dart';

//This class return a Shimmer Widget, That can be customize accordingly
class LoadPageShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
//                margin: EdgeInsets.only(top: 30),
                child: RoundShimmer()),
                 Expanded(child:ListViewShimmer(listLength: 6,))
            // _buildListViewWidget(),
          ],
        ),
      ),
    );
  }
}
