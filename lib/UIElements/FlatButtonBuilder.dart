import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets padding;
  final double bordeRRadius;
  final CustomStyle style;

  CustomFlatButton({@required this.onPressed, @required this.child, this.padding, @required this.bordeRRadius, @required this.style});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onPressed,
      child: this.child,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.style.borderRadius)),
      color: this.style.buttonColor,
      textColor: this.style.buttonTxtColor,
      padding:
          this.padding ?? EdgeInsets.symmetric(horizontal: this.style.height * 0.015, vertical: this.style.height * 0.015), //15
    );
  }
}
