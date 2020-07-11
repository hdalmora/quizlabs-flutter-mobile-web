import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ButtonMain extends StatelessWidget {

  final double width;
  final double height;
  final Color colorMain;
  final Color colorSec;
  final Color textColor;
  final double textSize;
  final String text;
  final VoidCallback onTap;
  final IconData icon;

  const ButtonMain({Key key, this.icon, this.textSize, this.textColor, this.width, this.height, this.colorMain, this.colorSec, this.text, this.onTap}) : super(key: key);

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
          padding: EdgeInsets.all(5),
          child: icon == null ? Text(
            text,
            style: Theme.of(context).textTheme.button.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: textSize ?? 14
            ),
          ) : Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             Text(
               text,
               style: Theme.of(context).textTheme.button.copyWith(
                   color: textColor ?? Colors.white,
                   fontWeight: FontWeight.bold,
                   fontSize: textSize ?? 16
               ),
             ),

             Icon(
               icon,
               size: 45,
               color: Colors.white,
             ),
           ],
          ),
        ),
      ),
    );
  }
}
