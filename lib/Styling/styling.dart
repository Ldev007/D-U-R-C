import 'package:flutter/material.dart';

class CustomStyle {
  Color dialogBkgColor = Colors.black.withOpacity(0.85);
  Color buttonColor = Colors.grey[800];
  Color buttonTxtColor = Colors.white;
  double borderRadius;
  Color borderColor = Colors.white60;
  Color focBorderColor = Colors.white;
  TextStyle dialogTitleTxtStyle;
  TextStyle dialogBodyTxtStyle;
  TextStyle labelTextStyle = TextStyle(color: Colors.white);
  TextStyle textFieldTextStyle = TextStyle(color: Colors.white);
  TextStyle homeScreenTitleTextStyle;
  Color fbColor = Colors.grey[800];
  Color fbTxtColor = Colors.white;
  Color backgroundColor = Colors.black54;
  Color appBarColor = Colors.grey[800];
  Color mainTxtColor = Colors.white;
  Color cursorColor = Colors.white;
  Color dropDownColor = Colors.grey[800];
  InputDecoration decor;
  double width = 0;
  double height = 0;
  TextStyle appBarTextStyle;

  CustomStyle({@required this.height}) {
    this.appBarTextStyle = TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.bold, letterSpacing: height * 0.0015);
    this.dialogTitleTxtStyle = TextStyle(fontSize: height * 0.02, color: Colors.white, fontWeight: FontWeight.bold);
    this.dialogBodyTxtStyle = TextStyle(color: Colors.white, fontSize: height * 0.014);
    this.homeScreenTitleTextStyle = TextStyle(color: mainTxtColor, fontSize: height * 0.022, fontWeight: FontWeight.bold);
    this.borderRadius = height * 0.015;
  }

  //For setting and getting input decoration
  InputDecoration toGetInputDecoration({String labelTxt}) {
    return InputDecoration(
      labelText: labelTxt,
      labelStyle: labelTextStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/*
TO-DO: TO IMPLEMENT RESPONSIVENESS IN A BETTER WAY

  double verticalFracts;

  double horizontalFracts;

  // CustomStyle({@required BoxConstraints constraints, @required Orientation orientation}) {
  //   CustomStyle.toSetWidthAndHeight(constraints: constraints, orientation: orientation);
  //   this.appBarTextStyle = TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.bold, letterSpacing: height * 0.0015);
  //   this.dialogTitleTxtStyle = TextStyle(fontSize: height * 0.02, color: Colors.white, fontWeight: FontWeight.bold);
  //   this.dialogBodyTxtStyle = TextStyle(color: Colors.white, fontSize: height * 0.014);
  //   this.homeScreenTitleTextStyle = TextStyle(color: mainTxtColor, fontSize: height * 0.022, fontWeight: FontWeight.bold);
  //   this.borderRadius = height * 0.015;
  // }

  
  CustomStyle.toSetWidthAndHeight({@required BoxConstraints constraints, @required Orientation orientation}) {
    if (orientation == Orientation.portrait) {
      verticalFracts = constraints.maxHeight / 100;
      horizontalFracts = constraints.maxWidth / 100;
    } else {
      verticalFracts = constraints.maxWidth / 100;
      horizontalFracts = constraints.maxHeight / 100;
    }
  }

  */
