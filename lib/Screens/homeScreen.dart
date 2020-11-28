import 'package:FARTtest/Dialogs/DeleteUserDialogBuilder.dart';
import 'package:FARTtest/Services/databaseService.dart';
import 'package:FARTtest/Styling/styling.dart';
import 'package:FARTtest/UIElements/FABBuilder.dart';
import 'package:FARTtest/UIElements/FlatButtonBuilder.dart';
import 'package:FARTtest/Dialogs/GeneralDialogBuilder.dart';
import 'package:FARTtest/Dialogs/UpdateUserDataDialog.dart';
import 'package:FARTtest/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, @required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //DATA MEMBER DECLARATION & INITIALISATION
  bool _initialisedOrNot = false;
  bool _errorOcurredOrNot = false;
  double dialogWidth, dialogHeight;
  bool dimensionsSet = false;
  double bordeRRadius;
  GlobalKey<ScaffoldState> scafKey = GlobalKey<ScaffoldState>();
  UserModel user = UserModel(); //USER OBJECT FOR STORING USER DATA
  CustomStyle style;

  @override
  void initState() {
    initFirebase();
    super.initState();
  }

  initFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialisedOrNot = true;
      });
    } on Exception catch (e) {
      print(e.toString());
      setState(() {
        _errorOcurredOrNot = true;
      });
    }
  }

  //INITIALISING DIMENSION VARIABLES
  initialiseDimensions() {
    dialogWidth = MediaQuery.of(context).size.width * 0.65;
    dialogHeight = MediaQuery.of(context).size.height * 0.3;
    bordeRRadius = MediaQuery.of(context).size.height * 0.013;
    style = CustomStyle(height: MediaQuery.of(context).size.height);
    setState(() {
      dimensionsSet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    !dimensionsSet ? initialiseDimensions() : print('dimensions set');
    return _initialisedOrNot
        ? Scaffold(
            backgroundColor: style.backgroundColor,
            key: scafKey,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: style.appBarColor,
              title: Text(widget.title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
            floatingActionButton: FABBuilder(
                width: dialogWidth,
                height: dialogHeight,
                bordeRRadius: bordeRRadius,
                user: user,
                cont: context,
                style: this.style),
            body: _errorOcurredOrNot ? buildThisIfErrorOccurs(context) : buildThisIfNoError(context))
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text('LOADING PLEASE WAIT A MOMENT..'),
                ],
              ),
            ),
          );
  }

  buildThisIfErrorOccurs(BuildContext context) => showDialog(
        context: context,
        child: Dialog(
          child: Container(
            color: style.dialogBkgColor,
            child: Column(
              children: [Text('Something went wrong couldn\'t initalise the app'), Icon(Icons.warning, color: Colors.red)],
            ),
          ),
        ),
      );

  buildThisIfNoError(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Divider(color: Colors.white),
          Expanded(
            child: Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                'CURRENT USERS',
                style: TextStyle(
                  color: style.mainTxtColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(color: Colors.white, endIndent: MediaQuery.of(context).size.height * 0.05),
          Expanded(
            flex: 15,
            child: StreamBuilder<QuerySnapshot>(
                stream: DBService(dialogHeight: dialogHeight, dialogWidth: dialogWidth, style: null).getSnapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    GeneralDialogBuilder(
                      style: style,
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Column(
                        children: [
                          Text('Some error occured !'),
                          Icon(Icons.close, color: Colors.red),
                        ],
                      ),
                    );

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            //backgroundColor: Colors.grey[800],
                          ),
                          SizedBox(height: 20),
                          Text('LOADING USER\'S LIST..', style: TextStyle(color: style.mainTxtColor)),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasData)
                    return Container(
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 15),
                        shrinkWrap: true,
                        itemCount: snapshot.data.size == null ? 0 : snapshot.data.size,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(snapshot.data.docs[index]['name'], style: TextStyle(color: style.mainTxtColor)),
                          subtitle: Text(snapshot.data.docs[index]['email'], style: TextStyle(color: style.mainTxtColor)),
                          onTap: () => GeneralDialogBuilder(
                            style: style,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                            width: dialogWidth,
                            height: dialogHeight,
                            child: Column(
                              children: [
                                Text('WHAT WOULD YOU LIKE TO DO ?', style: style.dialogTitleTxtStyle),
                                Divider(color: Colors.white),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomFlatButton(
                                        style: style,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width * 0.05,
                                            vertical: MediaQuery.of(context).size.height * 0.025),
                                        onPressed: () {
                                          UpdateUserDataDialog(
                                            borderRRadius: bordeRRadius,
                                            name: snapshot.data.docs[index]['name'],
                                            email: snapshot.data.docs[index]['email'],
                                            phone: snapshot.data.docs[index]['phone'].toString(),
                                            docID: snapshot.data.docs[index].id,
                                            width: dialogWidth,
                                            height: dialogHeight,
                                            style: style,
                                          ).buildDialog(scafKey.currentContext);
                                          // Navigator.pop(context);
                                        },
                                        child: Text('UPDATE USER DETAILS'),
                                        bordeRRadius: bordeRRadius,
                                      ),
                                      CustomFlatButton(
                                        style: style,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width * 0.085,
                                            vertical: MediaQuery.of(context).size.height * 0.025),
                                        onPressed: () => DeleteUserDialogBuilder(
                                          docID: snapshot.data.docs[index].id,
                                          width: dialogWidth,
                                          height: dialogHeight,
                                          borderRRadius: bordeRRadius,
                                          style: style,
                                        ).buildDialog(scafKey.currentContext),
                                        child: Text('DELETE THE USER'),
                                        bordeRRadius: bordeRRadius,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ).buildDialog(context),
                        ),
                        separatorBuilder: (context, index) => Divider(color: Colors.white, endIndent: 50),
                      ),
                    );
                  else
                    Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.grey[800],
                        ),
                        SizedBox(height: 20),
                        Text('LOADING USER\'S LIST..', style: TextStyle(color: style.mainTxtColor))
                      ]),
                    );
                }),
          ),
        ],
      );
}
