import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';

class FormFieldMain extends StatelessWidget {

  final TextInputType textInputType;
  final String hintText;
  final bool obscured;
  final void Function(void) onChanged;
  final String errorText;
  final bool enabled;
  final bool autoFocus;
  final double height;
  final int maxLines;

  const FormFieldMain({Key key, this.maxLines, this.height, this.autoFocus, this.enabled, this.textInputType, this.hintText, this.obscured, this.onChanged, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? Constants.mediaHeight(context)*.085,
        decoration: BoxDecoration(
          color: ColorUtils.GRAY_FORMS,
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: TextField(
              maxLines: maxLines ?? 1,
              autofocus: autoFocus ?? false,
              enabled: enabled != null ? enabled : true,
              textAlign: TextAlign.start,
              keyboardType: textInputType ?? TextInputType.text,
              onChanged: onChanged,
              style: TextStyle(fontSize: 18),
              obscureText: obscured ?? false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: Constants.mediaHeight(context)*.015, left: 15, right: 15),
                  errorText: errorText,
                  border: InputBorder.none,
                  hintText: hintText ?? ""
              ),
          ),
    );
  }
}
