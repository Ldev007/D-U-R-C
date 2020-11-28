import 'package:FARTtest/Services/databaseService.dart';
import 'package:FARTtest/Styling/styling.dart';
import 'package:FARTtest/UIElements/CustomTextFormField.dart';
import 'package:FARTtest/UIElements/FlatButtonBuilder.dart';
import 'package:FARTtest/models/userModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'InputDialogBuilder.dart';

class AddUserDialog {
  final double width;
  final double height;
  final UserModel user;
  final CustomStyle style;

  AddUserDialog({
    @required this.width,
    @required this.height,
    @required this.user,
    @required this.style,
  });

  GlobalKey<FormState> _addUserformKey = GlobalKey<FormState>();

  List<TextInputType> keyType = [TextInputType.name, TextInputType.emailAddress, TextInputType.phone];

  buildDialog(BuildContext context) {
    InputDialogBuilder(
      style: style,
      formKey: _addUserformKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'ADD A USER',
            style: style.dialogTitleTxtStyle,
          ),
          Divider(color: Colors.white),
          CustomTextFormField(
            inputType: keyType[0],
            onSaved: (value) {
              return value == null ? 'This field is compulsary' : this.user.name = value;
            },
            style: style,
            labelTxt: 'Enter Full Name',
          ).textFormField,
          CustomTextFormField(
            style: style,
            inputType: keyType[1],
            onSaved: (value) {
              return EmailValidator.validate(value) ? this.user.email = value : 'Enter a valid email';
            },
            labelTxt: 'Enter Email',
          ).textFormField,
          CustomTextFormField(
            onSaved: (value) {
              return value == null ? 'This field is compulsary' : this.user.phone = int.parse(value);
            },
            maxLen: 10,
            inputType: keyType[2],
            labelTxt: 'Enter Phone Number',
            style: style,
          ).textFormField,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFlatButton(
                  style: style,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'),
                  bordeRRadius: 10),
              SizedBox(width: 15),
              CustomFlatButton(
                  style: style,
                  onPressed: () {
                    _addUserformKey.currentState.save();
                    DBService(dialogHeight: this.height, dialogWidth: this.width, style: style)
                        .addUser(userObj: this.user, context: context);
                  },
                  child: Text('ADD USER'),
                  bordeRRadius: 10),
            ],
          ),
        ],
      ),
    ).buildDialog(context);
  }

  // custFB({@required void onPressed(), @required Widget child, EdgeInsets padding, double bordeRRadius}) {
  //   return FlatButton(
  //     onPressed: onPressed,
  //     child: child,
  //     color: CustomStyle().buttonColor,
  //     textColor: CustomStyle().buttonTxtColor,
  //     padding: padding ?? EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //   );
  // }
}
