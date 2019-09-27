import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:shimmer/shimmer.dart';

//This class return a Shimmer Widget, That can be customize accordingly
class ShimmerWidget extends StatelessWidget {
  final String imageName;

  const ShimmerWidget({Key key, @required this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: AppColors.colorGrey,
        child: Image.asset(
          imageName != null ? imageName : '',
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ));
  }
}
