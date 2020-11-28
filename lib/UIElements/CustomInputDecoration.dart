import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInputDecorBuilder {
  final String labelTxt;
  InputDecoration decor;
  final double borderRadius;

  final CustomStyle style;

  CustomInputDecorBuilder({@required this.borderRadius, @required this.labelTxt, @required this.style}) {
    this.decor = InputDecoration(
      labelText: this.labelTxt,
      labelStyle: this.style.labelTextStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: this.style.borderColor),
        borderRadius: BorderRadius.circular(this.borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: this.style.focBorderColor),
        borderRadius: BorderRadius.circular(this.borderRadius),
      ),
    );
  }
}
