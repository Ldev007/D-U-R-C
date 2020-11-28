import 'package:FARTtest/Services/databaseService.dart';
import 'package:FARTtest/Styling/styling.dart';
import 'package:FARTtest/UIElements/CustomTextFormField.dart';
import 'package:FARTtest/models/userModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../UIElements/FlatButtonBuilder.dart';
import 'InputDialogBuilder.dart';

class UpdateUserDataDialog {
  final String docID;
  final String name;
  final String email;
  final String phone;
  final double width;
  final double height;
  final double borderRRadius;
  final CustomStyle style;

  UpdateUserDataDialog({
    @required this.docID,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.width,
    @required this.height,
    @required this.borderRRadius,
    @required this.style,
  });

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel user = UserModel();

  buildDialog(BuildContext context) {
    InputDialogBuilder(
      style: style,
      formKey: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('UPDATE USER DATA', style: style.dialogTitleTxtStyle),
          Divider(color: Colors.white),
          CustomTextFormField(
            onSaved: (value) {
              print('HERE');
              if (value != '') user.name = value;
            },
            initValue: this.name,
            inputType: TextInputType.name,
            labelTxt: 'Name',
            style: style,
          ).textFormField,
          CustomTextFormField(
            onSaved: (value) {
              return EmailValidator.validate(value) ? user.email = value : 'Enter a valid email';
            },
            initValue: this.email,
            inputType: TextInputType.emailAddress,
            labelTxt: 'Email',
            style: style,
          ).textFormField,
          CustomTextFormField(
            onSaved: (value) {
              print('phone : $value');
              if (value != '') user.phone = int.parse(value);
            },
            initValue: this.phone,
            maxLen: 10,
            labelTxt: 'Phone',
            inputType: TextInputType.number,
            style: style,
          ).textFormField,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFlatButton(
                  style: style, onPressed: () => Navigator.pop(context), child: Text('CANCEL'), bordeRRadius: this.borderRRadius),
              SizedBox(width: MediaQuery.of(context).size.height * 0.01),
              CustomFlatButton(
                style: style,
                  bordeRRadius: this.borderRRadius,
                  onPressed: () {
                    formKey.currentState.save();

                    if (user.name != null || user.email != null || user.phone != null) {
                      DBService(dialogHeight: this.height, dialogWidth: this.width, style: this.style)
                          .updateDetails(nm: user.name, eml: user.email, phoneNo: user.phone, dID: this.docID, context: context);
                    } else
                      showDialog(
                        context: context,
                        child: Container(
                          width: this.width - 100,
                          height: this.height - 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 80),
                              Text('Enter all the values and try again !', style: style.dialogTitleTxtStyle),
                            ],
                          ),
                        ),
                      );
                  },
                  child: Text('UPDATE')),
            ],
          ),
        ],
      ),
    ).buildDialog(context);
    // Navigator.pop(context);
  }
}
