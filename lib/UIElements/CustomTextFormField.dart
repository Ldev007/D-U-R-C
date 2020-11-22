import 'package:FARTtest/Styling/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField {
  final String initValue;
  final String labelTxt;
  final TextInputType inputType;
  final FormFieldSetter<String> onSaved;
  final int maxLen;

  CustomTextFormField({this.initValue, this.labelTxt, this.inputType, this.onSaved, this.maxLen});

  buildTF(BuildContext context) {
    return TextFormField(
      onSaved: this.onSaved,
      style: TextStyle(color: Colors.white),
      initialValue: this.initValue,
      keyboardType: this.inputType,
      maxLength: this.maxLen == null ? null : this.maxLen,
      decoration: InputDecoration(
        labelText: this.labelTxt,
        labelStyle: TextStyle(color: CustomStyle().labelTxtColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomStyle().borderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomStyle().focBorderColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
