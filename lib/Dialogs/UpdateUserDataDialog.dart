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

  UpdateUserDataDialog({
    @required this.docID,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.width,
    @required this.height,
    @required this.borderRRadius,
  });

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel user = UserModel();

  buildDialog(BuildContext context) {
    InputDialogBuilder(
      formKey: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('UPDATE USER DATA',
              style: TextStyle(color: CustomStyle().dialogTitleTxtColor, fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(color: Colors.white),
          CustomTextFormField(
            onSaved: (value) {
              print('HERE');
              if (value != '') user.name = value;
            },
            initValue: this.name,
            inputType: TextInputType.name,
            labelTxt: 'Name',
          ).buildTF(context),
          CustomTextFormField(
            onSaved: (value) {
              return EmailValidator.validate(value) ? user.email = value : 'Enter a valid email';
            },
            initValue: this.email,
            inputType: TextInputType.emailAddress,
            labelTxt: 'Email',
          ).buildTF(context),
          CustomTextFormField(
            onSaved: (value) {
              print('phone : $value');
              if (value != '') user.phone = int.parse(value);
            },
            initValue: this.phone,
            maxLen: 10,
            labelTxt: 'Phone',
            inputType: TextInputType.number,
          ).buildTF(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFlatButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL'), bordeRRadius: this.borderRRadius),
              SizedBox(width: MediaQuery.of(context).size.height * 0.01),
              CustomFlatButton(
                  bordeRRadius: this.borderRRadius,
                  onPressed: () {
                    formKey.currentState.save();

                    if (user.name != null || user.email != null || user.phone != null) {
                      DBService(dialogHeight: this.height, dialogWidth: this.width)
                          .updateDetails(nm: user.name, eml: user.email, phoneNo: user.phone, dID: this.docID, ctx: context);
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
                              Text('Enter all the values and try again !',
                                  style: TextStyle(
                                      color: CustomStyle().dialogTitleTxtColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
