import 'package:FARTtest/Services/databaseService.dart';
import 'package:FARTtest/Styling/styling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final double w;
  final double h;
  SearchScreen({@required this.w, @required this.h});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String srchString = '';

  double dialogW, dialogH;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _menuItems = [
    DropdownMenuItem(
        child: Text('FILTER BY', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        value: 'filter_by'),
    DropdownMenuItem(child: Text('NAME', style: TextStyle(color: Colors.white)), value: 'name'),
    DropdownMenuItem(child: Text('EMAIL', style: TextStyle(color: Colors.white)), value: 'email'),
    DropdownMenuItem(child: Text('PHONE', style: TextStyle(color: Colors.white)), value: 'phone')
  ];

  String selectedVal = 'filter_by';
  String hintTxt = 'First choose a filter !';
  bool tfEnabledOrNot = false;

  _SearchScreenState({this.dialogW, this.dialogH});

  CustomStyle style = CustomStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.97,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  srchString != '' && selectedVal != 'filter_by'
                      ? Expanded(
                          flex: 12,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: DBService(dialogWidth: dialogW, dialogHeight: dialogH)
                                .searchResults(filterType: selectedVal, value: srchString),
                            builder: (context, snapshot) {
                              if (snapshot.hasError)
                                showDialog(
                                  context: context,
                                  child: Dialog(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Something went wrong couldn\'t initalise the app',
                                            style: TextStyle(color: style.dialogTitleTxtColor),
                                          ),
                                          Icon(Icons.warning, color: Colors.red)
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              if (snapshot.connectionState == ConnectionState.waiting)
                                return Center(
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Searching...',
                                          style: TextStyle(color: style.mainTxtColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                              if (snapshot.hasData)
                                return ListView.separated(
                                  itemCount: snapshot.data.size,
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text(snapshot.data.docs[index]['name'], style: TextStyle(color: Colors.white)),
                                    subtitle: Text(snapshot.data.docs[index]['email'], style: TextStyle(color: Colors.white)),
                                  ),
                                  separatorBuilder: (context, index) => Divider(color: Colors.white),
                                );
                            },
                          ),
                        )
                      : Expanded(
                          flex: 12,
                          child: Center(child: Text('SEARCH SOMETHING', style: TextStyle(color: style.mainTxtColor))),
                        ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Expanded(
                        flex: 6,
                        child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration:
                                BoxDecoration(border: Border.all(color: Colors.black45), borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      enabled: tfEnabledOrNot,
                                      onTap: () {
                                        if (selectedVal == 'filter_by')
                                          setState(() {
                                            hintTxt = 'First choose a filter !';
                                          });
                                      },
                                      onSaved: (value) {
                                        if (selectedVal == 'email') {
                                          bool isValid = EmailValidator.validate(value);
                                          if (isValid)
                                            srchString = value;
                                          else
                                            showDialog(
                                              context: context,
                                              child: Dialog(
                                                child: Container(
                                                  child: Center(
                                                    child: Text('Enter a valid email'),
                                                  ),
                                                ),
                                              ),
                                            );
                                        }
                                        srchString = value;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          srchString = value;
                                        });
                                      },
                                      style: TextStyle(color: style.mainTxtColor, fontSize: 18),
                                      cursorColor: style.cursorColor,
                                      cursorWidth: 0.9,
                                      decoration: InputDecoration(
                                        hintText: hintTxt,
                                        hintStyle: TextStyle(
                                          color: style.mainTxtColor,
                                          fontSize: 18,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    )),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: selectedVal,
                                      dropdownColor: style.dropDownColor,
                                      decoration: InputDecoration(
                                        // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        border: InputBorder.none,
                                      ),
                                      items: _menuItems,
                                      onChanged: (value) {
                                        print('Changed');
                                        setState(() {
                                          print(value);
                                          if (value == 'filter_by') {
                                            hintTxt = 'First choose a filter';
                                            tfEnabledOrNot = false;
                                            srchString = '';
                                            selectedVal = value;
                                          } else if (value == 'name') {
                                            hintTxt = 'Enter a name';
                                            tfEnabledOrNot = true;
                                            srchString = '';
                                            selectedVal = value;
                                          } else if (value == 'email') {
                                            hintTxt = 'Enter an email';
                                            tfEnabledOrNot = true;
                                            srchString = '';
                                            selectedVal = value;
                                          } else if (value == 'phone') {
                                            hintTxt = 'Enter a phone number';
                                            tfEnabledOrNot = true;
                                            srchString = '';
                                            selectedVal = value;
                                          }
                                        });
                                      }),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      _formKey.currentState.save();
                                      if (srchString == '' || selectedVal == 'filter_by') {
                                        invalidInputDialog();
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    icon: Icon(Icons.search, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  invalidInputDialog() {
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          color: Colors.black.withOpacity(0.85),
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.025, vertical: MediaQuery.of(context).size.height * 0.015),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'INVALID INPUT TRY AGAIN !',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.022, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.white),
              Text(
                '1) Choose a filter\n(NAME/EMAIL/PHONE NO) properly\n2) Enter the text respectively',
                softWrap: true,
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018, color: Colors.white, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
