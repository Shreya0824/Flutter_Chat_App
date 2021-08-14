import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailTextEditingController =new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading =false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: appBarMain(context),
    body: Container(
    alignment: Alignment.center,
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    Form(
    key: formKey,
    child:TextFormField(
    validator: (val){
    return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
    null : "Enter valid email";
    },
    controller:emailTextEditingController ,
    style: simpleTextFieldStyle(),
    decoration: textFieldInputDecoration("email"),
    ),
    ),
    RaisedButton(
      child: Text("Reset Password"),
        onPressed: (){
        authMethods.resetPass(emailTextEditingController.text);
      Navigator.of(context).pop();
        final snackBar = SnackBar(content: Text('Password change email request sent'));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

    ),
    ]
    ))));
  }
}
