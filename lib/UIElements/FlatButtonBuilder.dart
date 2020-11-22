import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets padding;
  final double bordeRRadius;

  CustomFlatButton({@required this.onPressed, @required this.child, this.padding, @required this.bordeRRadius});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onPressed,
      child: this.child,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.bordeRRadius)),
      color: CustomStyle().buttonColor,
      textColor: CustomStyle().buttonTxtColor,
      padding: this.padding ?? EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
