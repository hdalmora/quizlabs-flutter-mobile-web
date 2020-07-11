import 'package:flutter/material.dart';

class ButtonMain extends StatelessWidget {

  final double width;
  final double height;
  final Color colorMain;
  final Color colorSec;
  final Color textColor;
  final String text;
  final VoidCallback onTap;

  const ButtonMain({Key key, this.textColor, this.width, this.height, this.colorMain, this.colorSec, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: colorMain,
            borderRadius: new BorderRadius.circular(13.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colorSec,
                offset: new Offset(0, 6.0),
                blurRadius: 0,
              )
            ]
        ),

        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            text,
            style: Theme.of(context).textTheme.button.copyWith(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
