import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';


class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final List<Widget> widgets;

  const BaseAppBar({Key key, this.title,this.height, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      centerTitle: false,
      title: TextWidget(
        text: title,
        colorText: AppColors.colorWhite,
        textType: TextType.TEXT_LARGE,
      ),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}