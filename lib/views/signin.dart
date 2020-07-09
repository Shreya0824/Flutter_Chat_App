import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/signup.dart';
import 'package:flutter_chat_app/widgets/widget.dart';
import 'package:flutter_chat_app/helper/authenticate.dart';
import 'package:flutter_chat_app/views/chatRoomsScreen.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  TextEditingController emailEditingController =new TextEditingController();
  TextEditingController passwordEditingController =new TextEditingController();
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() async {
    if (formKey.currentState.validate()) {

      HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);
      databaseMethods.getUserInfo(emailEditingController.text).then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });
    }
      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailEditingController.text, passwordEditingController.text).then((val) {
        if(val!=null)
          {

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => ChatRoomsScreen()

            ));
          }
        else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
});}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
      ? Container(
      child: Center(child: CircularProgressIndicator()),
      )
          : Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(

            validator: (val){
              return val.isEmpty ? "Please Enter Email " : null;
            },
                      controller: emailEditingController,
            decoration: InputDecoration(
                        hintText: "Email"
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordEditingController,
                      validator:  (val){
                        return val.length < 6 ? "Please enter password of atleast 6 characters" : null;
                      },
                        decoration: InputDecoration(
                            hintText: "Password"
                        ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign In",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

    SizedBox(height: 40,),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Text("Don't have an account?"),

        GestureDetector(
        onTap: () {
          widget.toggleView();


    },
    child:
        Text("Register now" , style: (TextStyle(
    decoration: TextDecoration.underline
    )

    ),),),
    ],
    ),
              SizedBox(height: 80,),
            ],
          ),
        ),
      );


  }}
