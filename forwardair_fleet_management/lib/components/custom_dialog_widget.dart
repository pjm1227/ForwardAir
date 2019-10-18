import 'package:flutter/material.dart';

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
            TextWidget(
              text: description,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: ButtonWidget(
                    text: 'Dial 911',

                  ),
                ),
                Container(
                  child: ButtonWidget(
                    text: 'Continue',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
