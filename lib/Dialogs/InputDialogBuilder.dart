import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/material.dart';

class InputDialogBuilder {
  final GlobalKey<FormState> formKey;
  final Widget child;

  InputDialogBuilder({this.formKey, this.child});

  buildDialog(BuildContext context) {
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          color: CustomStyle().dialogBkgColor,
          child: Form(
            key: this.formKey,
            child: this.child,
          ),
        ),
      ),
    );
  }
}
