import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/widgets/widget.dart';
import 'package:flutter_chat_app/views/chatRoomsScreen.dart';
import 'package:flutter_chat_app/helper/theme.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController usernameTextEditingController =new TextEditingController();
  TextEditingController emailTextEditingController =new TextEditingController();
  TextEditingController passwordTextEditingController =new TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods = new DatabaseMethods();

  singUp() async {

    if(formKey.currentState.validate()){
      setState(() {

        isLoading = true;
      });

      await authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((result){
        if(result != null){

          Map<String,String> userDataMap = {
            "name" : usernameTextEditingController.text,
            "email" : emailTextEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(usernameTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoomsScreen()
          ));
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
          child: Container(
            height: 400,
            width: 400,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
                children: [
                  Spacer(),
                  Form(
                    key: formKey,
                  child: Column(
                    children: [
                TextFormField(
                  style: simpleTextStyle(),
                controller: usernameTextEditingController,
                  validator: (val){
                    return val.isEmpty  ? "Please Enter Username " : null;
                  },
                  decoration: InputDecoration(

                      hintText: "Username"
                  ),
                ),
                TextFormField(
                  style: simpleTextStyle(),
                  controller: emailTextEditingController,
                  validator: (val){
                    return val.isEmpty ? "Please Enter Email " : null;
                  },
                  decoration: InputDecoration(
                      hintText: "Email"
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordTextEditingController,
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
               SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  singUp();
                },
                child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC),
                        ]
                    )
          ),
          child: Text("Sign Up"),

        ),
              ),
            SizedBox(
            height: 30,
          ),


        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Already have an account?"),
    GestureDetector(
    onTap: () {
    widget.toggleView();
    },
    child:
        Text("SignIn now" , style: (TextStyle(
        decoration: TextDecoration.underline
        )
        ),),),
        ],
        )
                ],
  ),

    ),
    ),
    );

  }
}
