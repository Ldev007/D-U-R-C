import 'package:FARTtest/Dialogs/AddUserDialog.dart';
import 'package:FARTtest/Styling/styling.dart';
import 'package:FARTtest/Screens/searchScreen.dart';
import 'package:FARTtest/models/userModel.dart';
import 'package:flutter/material.dart';

class FABBuilder extends StatefulWidget {
  final double width;
  final double height;
  final double bordeRRadius;
  final UserModel user;
  final BuildContext cont;

  FABBuilder(
      {@required this.width, @required this.height, @required this.bordeRRadius, @required this.user, @required this.cont});

  @override
  _FABBuilderState createState() => _FABBuilderState();
}

class _FABBuilderState extends State<FABBuilder> {
  CustomStyle style = CustomStyle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            backgroundColor: style.fbColor,
            heroTag: 'Bn1',
            label: Row(
                children: [Text('SEARCH', style: TextStyle(color: style.fbTxtColor)), SizedBox(width: 5), Icon(Icons.search)]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.widget.bordeRRadius)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => SearchScreen(w: this.widget.width, h: this.widget.height)),
            ),
          ),
          FloatingActionButton.extended(
            backgroundColor: style.fbColor,
            heroTag: 'Bn2',
            label: Row(children: [Text('ADD USER'), SizedBox(width: 5), Icon(Icons.person_add)]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.widget.bordeRRadius)),
            onPressed: () => AddUserDialog(width: this.widget.width, height: this.widget.height, user: this.widget.user)
                .buildDialog(this.widget.cont),
          ),
          /*
          Was meant for testing duplicacy check
          
          FloatingActionButton.extended(
            backgroundColor: style.fbColor,
            heroTag: 'Bn3',
            label: Row(children: [Text('DUPLICACY CHECK'), SizedBox(width: 5), Icon(Icons.person_add)]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.widget.bordeRRadius)),
            onPressed: () => DBService(dialogHeight: this.widget.height, dialogWidth: this.widget.width)
                .checkDuplicacy(field: 'name', value: 'loki', context: context),
          ),
          */
        ],
      ),
    );
  }
}
