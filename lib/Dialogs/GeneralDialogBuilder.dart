import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/material.dart';

class GeneralDialogBuilder {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;

  GeneralDialogBuilder({@required this.child, this.width, this.height, this.padding});

  buildDialog(BuildContext context) {
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          width: this.width,
          height: this.height,
          color: CustomStyle().dialogBkgColor,
          child: this.child,
          padding: this.padding == null ? null : this.padding,
        ),
      ),
    );
  }
}
