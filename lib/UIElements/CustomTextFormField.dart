import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField {
  final String initValue;
  final String labelTxt;
  final TextInputType inputType;
  final FormFieldSetter<String> onSaved;
  final int maxLen;
  final CustomStyle style;

  TextFormField textFormField;

  CustomTextFormField(
      {this.initValue,
      @required this.labelTxt,
      @required this.inputType,
      @required this.onSaved,
      this.maxLen,
      @required this.style}) {
    this.textFormField = TextFormField(
      onSaved: this.onSaved,
      style: style.textFieldTextStyle,
      initialValue: this.initValue,
      keyboardType: this.inputType,
      maxLength: this.maxLen == null ? null : this.maxLen,
      decoration: this.style.toGetInputDecoration(labelTxt: this.labelTxt),
    );
  }
}
