import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/material.dart';

class GeneralDialogBuilder {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;
  final CustomStyle style;

  GeneralDialogBuilder({@required this.child, @required this.width, @required this.height, this.padding, @required this.style});

  buildDialog(BuildContext context) {
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          width: this.width,
          height: this.height,
          color: this.style.dialogBkgColor,
          child: this.child,
          padding: this.padding == null ? EdgeInsets.only() : this.padding,
        ),
      ),
    );
  }
}
