import 'package:FARTtest/Services/databaseService.dart';
import 'package:flutter/material.dart';
import '../UIElements/FlatButtonBuilder.dart';
import 'GeneralDialogBuilder.dart';

class DeleteUserDialogBuilder {
  final String docID;
  final double width;
  final double height;
  final double borderRRadius;

  DeleteUserDialogBuilder({@required this.docID, @required this.width, @required this.height, @required this.borderRRadius});

  buildDialog(BuildContext context) {
    GeneralDialogBuilder(
      width: this.width,
      height: this.height - 100,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text('ARE YOU SURE ?', style: TextStyle(fontSize: 25, color: Colors.white)),
              Divider(color: Colors.white),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomFlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('NO'),
                bordeRRadius: borderRRadius
              ),
              SizedBox(width: 25),
              CustomFlatButton(
                onPressed: () {
                  DBService(dialogHeight: this.height, dialogWidth: this.width).deleteUser(ctx: context, docId: this.docID);
                },
                child: Text('YES'),
                bordeRRadius: borderRRadius,
              ),
            ],
          ),
        ],
      ),
    ).buildDialog(context);
  }
}
