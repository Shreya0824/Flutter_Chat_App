import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/authenticate.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/helper/theme.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/conversation_screen.dart';
import 'package:flutter_chat_app/views/search.dart';
import 'package:flutter_chat_app/widgets/widget.dart';
class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                name: snapshot.data.documents[index].data['chatroomid']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatroomid: snapshot.data.documents[index].data["chatroomid"],
              );
            })
            : Container();
      },
    );
  }
  AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods =new DatabaseMethods();
  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots){
      setState(() {
        chatRooms =snapshots;

      });
    });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("FlutterChatApp"),
actions : [
  GestureDetector(
    onTap: (){
      AuthMethods().signOut();

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Authenticate()));
    },
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.exit_to_app)),
  )
],
    ),

      body: Container(
        child:chatRoomsList(),
      ),
    floatingActionButton: FloatingActionButton(
    child: Icon(Icons.search),
    onPressed: () {
    Navigator.push(
    context, MaterialPageRoute(builder: (context) => Search()));
    },
    ),
    );

  }}


class ChatRoomsTile extends StatelessWidget {
  final String name;
  final String chatroomid;

  ChatRoomsTile({this.name,@required this.chatroomid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => conversation_screen(
              chatroomid: chatroomid,
            )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),

        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(name.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),

      ),

    );

  }}
