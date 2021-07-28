import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context){
  return AppBar(
    title: Center(
        child: Text("Flutter Chat App")),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle:TextStyle(
    color: Colors.white54,
  ),
  focusedBorder: UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white)
  ),
  enabledBorder: UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white)
  ),
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color: Colors.white,
      fontSize: 14
  );
}

TextStyle mediumTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 20
  );
}