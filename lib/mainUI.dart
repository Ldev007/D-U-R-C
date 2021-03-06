import 'package:FARTtest/Screens/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TO IMPLEMENT RESPONSIVENESS IN A BETTER WAY
    // return LayoutBuilder(
    //   builder: (context, constraints) => OrientationBuilder(
    //     builder: (context, orientation) {
    //       CustomStyle(constraints: constraints, orientation: orientation);
    //       return MaterialApp(
    //         title: 'Flutter Demo',
    //         theme: ThemeData(
    //           primarySwatch: Colors.blue,
    //           visualDensity: VisualDensity.adaptivePlatformDensity,
    //         ),
    //         home: MyHomePage(title: 'C-R-U-D'),
    //       );
    //     },
    //   ),
    // );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'C-R-U-D'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HomeScreen(title: 'C-R-U-D');
  }
}
