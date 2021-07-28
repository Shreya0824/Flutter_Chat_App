import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/conversation_screen.dart';
import 'package:flutter_chat_app/views/search.dart';
import 'package:flutter_chat_app/views/singin.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class chatRoom extends StatefulWidget {

  @override
  _chatRoomState createState() => _chatRoomState();
}

class _chatRoomState extends State<chatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late Stream<QuerySnapshot> chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomsStream,
        builder: (context,snapshot){
return snapshot.hasData?ListView.builder(
    itemCount: snapshot.data!.docs.length,
    itemBuilder: (context,index) {
      return ChatRoomTile(userName: snapshot.data!.docs[index]["chatRoomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),chatRoomId: snapshot.data!.docs[index]["chatRoomId"],) ;
    }
):Container();
        });
  }

@override
void initState(){
  getUserInfo();
  super.initState();
}
  getUserInfo()async{
    Constants.myName= (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomsStream=val;
      });  });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Expanded(child: Text("Flutter Chat App")),
        actions:[
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> SignIn()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),

        ],
      ),
     body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
           child: Icon(Icons.search),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));

          },
        ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
final String userName;
final String chatRoomId;

ChatRoomTile({required this.userName,required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ConversationScreen(chatRoomId: chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            SizedBox(width: 15),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 15,),
            Text(userName,style: mediumTextFieldStyle(),),
          ],
        ),
      ),
    );
  }
}

