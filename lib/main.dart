import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/views/chat_room_screen.dart';
import 'package:flutter_chat_app/views/singin.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late bool userLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value)
    {
setState(() {
  userLoggedIn  = value!;
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
        scaffoldBackgroundColor: Colors.black87,
      ),
      home: userLoggedIn?chatRoom():SignIn(),
    );
  }
}
