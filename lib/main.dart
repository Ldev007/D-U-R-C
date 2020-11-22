import 'package:FARTtest/Screens/searchScreen.dart';
import 'package:FARTtest/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Services/databaseService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'C-R-U-D'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _initialisedOrNot = false;
  bool _errorOcurredOrNot = false;
  double dialogWidth, dialogHeight;
  bool dimensionsSet = false;

  Color buttonColor = Colors.black.withOpacity(0.7);

  double bordeRRadius;

  GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
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
      setState(() {
        _errorOcurredOrNot = true;
      });
    }
  }

  initialiseDimensions() {
    dialogWidth = MediaQuery.of(context).size.width * 0.65;
    dialogHeight = MediaQuery.of(context).size.height * 0.3;
    bordeRRadius = MediaQuery.of(context).size.height * 0.013;
    setState(() {
      dimensionsSet = true;
    });
  }

  GlobalKey<ScaffoldState> scafKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    !dimensionsSet ? initialiseDimensions() : print('dimensions set');
    return _initialisedOrNot
        ? Scaffold(
            key: scafKey,
            appBar: AppBar(
              title: Text(widget.title),
            ),
            floatingActionButton: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'Bn1',
                    label: Row(children: [Text('SEARCH'), SizedBox(width: 5), Icon(Icons.search)]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius)),
                    onPressed: () => buildSearchWidget(context),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'Bn2',
                    label: Row(children: [Text('ADD USER'), SizedBox(width: 5), Icon(Icons.person_add)]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius)),
                    onPressed: () => buildAddUserDialog(context),
                  ),
                ],
              ),
            ),
            body: _errorOcurredOrNot ? buildThisIfErrorOccurs(context) : buildThisIfNoError(context))
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('LOADING PLEASE WAIT A MOMENT..'),
              ],
            ),
          );
  }

  buildSearchWidget(BuildContext ctx) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => SearchScreen(w: dialogWidth, h: dialogHeight)));

  buildThisIfErrorOccurs(BuildContext context) => showDialog(
        context: context,
        child: Dialog(
          child: Container(
            child: Column(
              children: [Text('Something went wrong couldn\'t initalise the app'), Icon(Icons.warning, color: Colors.red)],
            ),
          ),
        ),
      );

  GlobalKey<FormState> _addUserformKey = GlobalKey<FormState>();
  UserModel user = UserModel();

  Future buildAddUserDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: Dialog(
        child: Container(
          child: Form(
            key: _addUserformKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    return value == null ? 'This field is compulsary' : user.name = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Full Name',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    return value == null ? 'This field is compulsary' : user.email = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                  ),
                ),
                TextFormField(
                  onSaved: (value) {
                    return value == null ? 'This field is compulsary' : user.phone = int.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    _addUserformKey.currentState.save();
                    DBService(dialogHeight: dialogHeight, dialogWidth: dialogWidth).addUser(userObj: user, context: context);
                  },
                  child: Text('ADD USER'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteUserDialog(BuildContext context, String docID) => showDialog(
        context: context,
        child: Dialog(
          child: Container(
            width: dialogWidth,
            height: dialogHeight - 100,
            padding: EdgeInsets.symmetric(horizontal: 15),
            color: Colors.black.withOpacity(0.85),
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
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius)),
                      color: Colors.white60,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('NO'),
                    ),
                    SizedBox(width: 25),
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius)),
                      color: Colors.white60,
                      onPressed: () {
                        DBService(dialogHeight: dialogHeight, dialogWidth: dialogWidth).deleteUser(ctx: context, docId: docID);
                        Navigator.pop(context);
                      },
                      child: Text('YES'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  buildThisIfNoError(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                'CURRENT USERS IN THE DATABASE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
                stream: DBService(dialogHeight: dialogHeight, dialogWidth: dialogWidth).getSnapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    showDialog(
                      context: context,
                      child: Dialog(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Column(
                            children: [
                              Text('Some error occured !'),
                              Icon(Icons.close, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData)
                    return Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.size == null ? 0 : snapshot.data.size,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(snapshot.data.docs[index]['name']),
                          subtitle: Text(snapshot.data.docs[index]['email']),
                          onTap: () => showDialog(
                              context: context,
                              child: Dialog(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                                  width: dialogWidth,
                                  height: dialogHeight,
                                  child: Column(
                                    children: [
                                      Text('WHAT WOULD YOU LIKE TO DO ?',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * 0.02,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FlatButton(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius)),
                                              color: buttonColor,
                                              textColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.of(context).size.width * 0.05,
                                                  vertical: MediaQuery.of(context).size.height * 0.025),
                                              onPressed: () => updateUserDetails(
                                                  name: snapshot.data.docs[index]['name'],
                                                  email: snapshot.data.docs[index]['email'],
                                                  phone: snapshot.data.docs[index]['phone'].toString(),
                                                  docID: snapshot.data.docs[index].id),
                                              child: Text('UPDATE USER DETAILS'),
                                            ),
                                            FlatButton(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius)),
                                              color: buttonColor,
                                              textColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.of(context).size.width * 0.085,
                                                  vertical: MediaQuery.of(context).size.height * 0.025),
                                              onPressed: () => deleteUserDialog(context, snapshot.data.docs[index].id),
                                              child: Text('DELETE THE USER'),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                    );
                  else
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator(), Text('LOADING USER\'S LIST..')]);
                }),
          ),
        ],
      );

  updateUserDetails({@required String docID, @required String name, @required String email, @required String phone}) {
    Color txtColor = Colors.white;
    Color borderColor = Colors.white;
    Color focBorderColor = Colors.white60;
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          color: Colors.black.withOpacity(0.85),
          child: Form(
            key: _updateFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('UPDATE USER DATA', style: TextStyle(color: txtColor, fontSize: 20, fontWeight: FontWeight.bold)),
                Divider(color: Colors.white),
                TextFormField(
                  onSaved: (value) {
                    if (value != '') user.name = value;
                  },
                  style: TextStyle(color: Colors.white),
                  initialValue: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: txtColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: focBorderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                TextFormField(
                  onSaved: (value) {
                    if (value != '') user.email = value;
                  },
                  style: TextStyle(color: Colors.white),
                  initialValue: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: txtColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: focBorderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                TextFormField(
                  onSaved: (value) {
                    print('phone : $value');
                    if (value != '') user.phone = int.parse(value);
                  },
                  initialValue: phone,
                  style: TextStyle(color: Colors.white),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: txtColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: focBorderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius - 4)),
                        color: Colors.white70,
                        onPressed: () => Navigator.pop(context),
                        child: Text('CANCEL')),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                    FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bordeRRadius - 4)),
                        color: Colors.white70,
                        onPressed: () {
                          _updateFormKey.currentState.save();

                          if (user.name != null && user.email != null && user.phone != null)
                            DBService(dialogHeight: dialogHeight, dialogWidth: dialogWidth)
                                .updateDetails(nm: user.name, eml: user.email, phoneNo: user.phone, dID: docID, ctx: context);
                          else
                            showDialog(
                              context: context,
                              child: Dialog(
                                child: Container(
                                  color: Colors.black.withOpacity(0.85),
                                  width: dialogWidth - 100,
                                  height: dialogHeight - 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, color: Colors.red, size: 80),
                                      Text('Enter all the values and try again !',
                                          style: TextStyle(color: txtColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                        },
                        child: Text('UPDATE')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
