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

  AddUserDialog({@required this.width, @required this.height, @required this.user});

  GlobalKey<FormState> _addUserformKey = GlobalKey<FormState>();

  buildDialog(BuildContext context) {
    InputDialogBuilder(
      formKey: _addUserformKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'ADD A USER',
            style: TextStyle(fontSize: 20, color: CustomStyle().dialogTitleTxtColor, fontWeight: FontWeight.bold),
          ),
          Divider(color: Colors.white),
          CustomTextFormField(
            inputType: TextInputType.name,
            onSaved: (value) {
              return value == null ? 'This field is compulsary' : this.user.name = value;
            },
            labelTxt: 'Enter Full Name',
          ).buildTF(context),
          CustomTextFormField(
            inputType: TextInputType.emailAddress,
            onSaved: (value) {
              return EmailValidator.validate(value) ? this.user.email = value : 'Enter a valid email';
            },
            labelTxt: 'Enter Email',
          ).buildTF(context),
          CustomTextFormField(
            onSaved: (value) {
              return value == null ? 'This field is compulsary' : this.user.phone = int.parse(value);
            },
            maxLen: 10,
            inputType: TextInputType.number,
            labelTxt: 'Enter Phone Number',
          ).buildTF(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'),
                  bordeRRadius: 10),
              SizedBox(width: 15),
              CustomFlatButton(
                  onPressed: () {
                    _addUserformKey.currentState.save();
                    DBService(dialogHeight: this.height, dialogWidth: this.width).addUser(userObj: this.user, context: context);
                  },
                  child: Text('ADD USER'),
                  bordeRRadius: 10),
            ],
          ),
        ],
      ),
    ).buildDialog(context);
  }

  custFB({@required void onPressed(), @required Widget child, EdgeInsets padding, double bordeRRadius}) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
      color: CustomStyle().buttonColor,
      textColor: CustomStyle().buttonTxtColor,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
