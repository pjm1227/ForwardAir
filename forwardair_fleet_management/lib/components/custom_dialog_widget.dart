import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';

import 'button_widget.dart';
import 'text_widget.dart';

class CustomDialog extends StatelessWidget {
  final String description;
  final Image image;

  CustomDialog({
    @required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextWidget(
                text: description,
                textType: TextType.TEXT_MEDIUM,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Container(
                        color: AppColors.colorRed,
                        height: 30,
                        width: MediaQuery.of(context).size.width * .30,
                        child: Center(
                          child: Container(
                            child: TextWidget(
                              text: 'Dial 911',
                              isBold: true,
                              colorText: AppColors.colorWhite,
                            ),
                          ),
                        )),
                    onTap: () => Navigator.pop(context),
                  ),
                  InkWell(
                    child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * .30,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.colorRed)),
                        child: Center(
                          child: Container(
                            child: TextWidget(text: 'Continue',
                            isBold: true,
                            colorText: AppColors.colorRed,),
                          ),
                        )),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
