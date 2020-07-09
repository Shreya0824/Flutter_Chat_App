import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/authenticate.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/views/chatRoomsScreen.dart';
import 'helper/helperfunctions.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  @override
  void initState() {
getLoggedInState();
    super.initState();
  }


  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){

      setState(() {
        userIsLoggedIn  = value;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null ?  ChatRoomsScreen() : Authenticate()

    ); }
}

