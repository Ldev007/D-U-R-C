import 'dart:async';
import 'package:FARTtest/Styling/styling.dart';
import 'package:FARTtest/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DBService {
  CollectionReference usrCollection = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getSnapshots() {
    return usrCollection.snapshots();
  }

  DBService({@required this.dialogHeight, @required this.dialogWidth});

  CustomStyle style = CustomStyle();

//Create record
  addUser({UserModel userObj, BuildContext context}) async {
    print('Adding user...');
    bool emlCheck = true, nameCheck = true, phoneCheck = true;
    emlCheck = await checkDuplicacy(field: 'email', value: userObj.email, context: context);
    nameCheck = await checkDuplicacy(field: 'name', value: userObj.name, context: context);
    phoneCheck = await checkDuplicacy(field: 'phone', value: userObj.phone.toString(), context: context);
    if (emlCheck || phoneCheck || nameCheck) {
      showDialog(
          child: Dialog(
            child: Container(
              color: style.dialogBkgColor,
              width: dialogWidth,
              height: dialogHeight - 50,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('ACCOUNT ALREADY EXISTS !',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      Divider(color: Colors.white),
                    ],
                  ),
                  Text('Please try again with a different name, email or phone number or you can try again later',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          color: style.buttonColor,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('CANCEL', style: TextStyle(color: style.buttonTxtColor))),
                      SizedBox(width: 15),
                      FlatButton(
                          color: style.buttonColor,
                          onPressed: () => Navigator.pop(context),
                          child: Text('TRY AGAIN', style: TextStyle(color: style.buttonTxtColor))),
                    ],
                  )
                ],
              ),
            ),
          ),
          context: context);
    } else
      usrCollection.add({
        'name': userObj.name,
        'phone': userObj.phone,
        'email': userObj.email,
      }).then((value) {
        Navigator.pop(context);
        showDialog(
          context: context,
          child: Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: Colors.black.withOpacity(0.85),
              width: dialogWidth - 100,
              height: dialogHeight - 100,
              child: Column(
                children: [
                  Text('User added successfully !',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.check, color: Colors.green, size: 80),
                ],
              ),
            ),
          ),
        );
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }).catchError((error) => showDialog(
            child: Dialog(
              child: Container(
                child: Column(
                  children: [
                    Text('Something gone wrong'),
                    Icon(Icons.close, color: Colors.red),
                  ],
                ),
              ),
            ),
            context: context,
          ));
  }

  //Read record
  Stream<QuerySnapshot> searchResults({@required String filterType, @required String value}) {
    return usrCollection.where('$filterType', isEqualTo: value).snapshots();
  }

//Update record
  updateDetails({String nm, String eml, int phoneNo, String dID, BuildContext ctx}) {
    usrCollection.doc(dID).update(
      {'name': nm, 'email': eml, 'phone': phoneNo},
    ).then(
      (value) {
        Navigator.pop(ctx);
        Navigator.pop(ctx);
        showDialog(
          context: ctx,
          barrierDismissible: false,
          child: Dialog(
            child: Container(
              width: dialogWidth - 100,
              height: dialogHeight - 100,
              color: style.dialogBkgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.check, color: Colors.green, size: 80),
                  Text('USER DETAILS UPDATED SUCCESSFULLY !',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
        Timer(Duration(seconds: 2), () {
          Navigator.pop(ctx);
        });
      },
    );
  }

  bool dimensionsSet = false;
  double dialogWidth, dialogHeight;

//Delete record
  deleteUser({BuildContext ctx, String docId}) async {
    usrCollection.doc(docId).delete().then((value) {
      Navigator.pop(ctx);
      Navigator.pop(ctx);
      showDialog(
        context: ctx,
        barrierDismissible: false,
        child: Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.black.withOpacity(0.85),
            width: dialogWidth - 100,
            height: dialogHeight - 100,
            child: Column(
              children: [
                Icon(Icons.check, color: Colors.green, size: 80),
                Text('User deleted successfully !',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      );
      Timer(Duration(seconds: 2), () {
        Navigator.pop(ctx);
      });
    }).catchError((error) => showDialog(
          child: Dialog(
            child: Container(
              child: Column(
                children: [
                  Text('Something gone wrong'),
                  Icon(Icons.close, color: Colors.red),
                ],
              ),
            ),
          ),
          context: ctx,
        ));
  }

  Future<bool> checkDuplicacy({String field, String value, @required BuildContext context}) {
    return usrCollection.where(field, isEqualTo: value).get().then((value) {
      if (value.docs.length > 0)
        return true;
      else
        return false;
    });
  }
}
