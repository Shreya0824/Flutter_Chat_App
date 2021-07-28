import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/singin.dart';
import 'package:flutter_chat_app/widgets/widget.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'chat_room_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =new TextEditingController();
  TextEditingController emailTextEditingController =new TextEditingController();
  TextEditingController passwordTextEditingController =new TextEditingController();
  bool isLoading =false;
  AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods = new DatabaseMethods();

  signValidator(){
    if(formKey.currentState!.validate()){
      Map<String,String>userMap={
        "name":userNameTextEditingController.text,
        "email":emailTextEditingController.text,
      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
setState(() {
  isLoading=true;
});
authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text);
      databaseMethods.uploadUserInfo(userMap);
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=> chatRoom()
      ));
    }


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):
      Container(
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
                    TextFormField(
                      validator:(val){
                        return val!.isEmpty ? "Please provide username" : null;
                      },
                      style: simpleTextFieldStyle(),
                      controller: userNameTextEditingController,
                      decoration: textFieldInputDecoration("username"),
                    ),
                    TextFormField(
                      validator: (val){
                        return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                        null : "Enter valid email";
                      },
                      controller: emailTextEditingController,
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
              SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  signValidator();
                },
                child: Container(
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
                  child: Text("Sign Up",style: mediumTextFieldStyle(),),
                ),
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
                child: Text("Sign up with Google",style: mediumTextFieldStyle(),),
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ? ",style: simpleTextFieldStyle(),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
                      },
                    child: Text("SignIn now",style: TextStyle(
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
    );
  }
}
