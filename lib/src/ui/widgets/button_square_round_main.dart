import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';

class ButtonSquareRoundMain extends StatelessWidget {

  final VoidCallback onTap;
  final String text;

  const ButtonSquareRoundMain({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          width: 140,
          height: 135,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: ColorUtils.GRAY_LIGHT,
              borderRadius: new BorderRadius.circular(13.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: ColorUtils.GRAY_DARK,
                  offset: new Offset(5.0, 5.0),
                  blurRadius: 0,
                )
              ]
          ),
          child: Column(
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: ColorUtils.GRAY_FORM_HINT,
                    fontWeight: FontWeight.normal,
                    fontSize: 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
