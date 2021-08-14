import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/signup.dart';
import 'package:flutter_chat_app/widgets/widget.dart';
import 'chat_room_screen.dart';
import 'forgetpassword.dart';
import 'package:lottie/lottie.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController passwordTextEditingController =new TextEditingController();
  TextEditingController emailTextEditingController =new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading =false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot userInfoSnapshot;
  signIn() async {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      databaseMethods.getuserByUserEmail(emailTextEditingController.text).then((val){
        userInfoSnapshot=val;

        HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.docs[0]["userName"]);
      });


      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text)
          .then((result) async {
        if (result != null) {

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => chatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40,),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(45.0),
                        child: Lottie.asset('assets/41556-chatting-between-boy-and-girl (1).json'),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        validator: (val){
                          return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                          null : "Enter valid email";
                        },
                        controller:emailTextEditingController ,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val!.length>6 ? null : "Please enter password with 6+ characters ";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));                },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text("Forgot Password ?",style: simpleTextFieldStyle(),),),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blueAccent,
                      ]
                    )
                  ),
                  child: GestureDetector(
                      onTap: (){
                        signIn();
                      },
                      child: Text("Sign In",style: mediumTextFieldStyle(),)),
                ),
                SizedBox(height: 15,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.blueAccent,
                          ]
                      )
                  ),
                  child: Text("Sign in with Google",style: mediumTextFieldStyle(),),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ? ",style: simpleTextFieldStyle(),),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      child: Text("Register now",style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        decoration: TextDecoration.underline
                      ),),
                    ),
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
