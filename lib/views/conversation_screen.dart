import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/widgets/widget.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationScreen extends StatefulWidget {
final String chatRoomId;
ConversationScreen({required this.chatRoomId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
 late Stream<QuerySnapshot> chatMessagesStream;

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
setState(() {
  chatMessagesStream=val;

});    });
    super.initState();
  }

  Widget ChatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream:chatMessagesStream, builder: (context, snapshot) {
      return snapshot.hasData?ListView.builder(
          shrinkWrap: true,
          itemCount:snapshot.data!.docs.length ,
          itemBuilder: (context,index){
            return MessageTile(message:snapshot.data!.docs[index]['message'],isSendByMe: snapshot.data!.docs[index]['sendBy']==Constants.myName,);
          }):Container();
    },
    );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty)
    {
      Map<String,String>messageMap={
        "message":messageController.text,
        "sendBy":Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      };
      databaseMethods.addConversationMessages(widget.chatRoomId,messageMap );
      messageController.text="";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text("Flutter Chat App")),
      ),
      body:Container(
        child: Stack(
          children: [
            ChatMessageList(),
           Container(
             alignment: Alignment.bottomCenter,
             child:  Container(
               padding: EdgeInsets.all(10),
               color: Color(0x54FFFFFF),
               child: Row(
                 children: [
                   Expanded(child: TextField(
                     controller: messageController,
                     style: TextStyle(
                         color: Colors.white
                     ),
                     decoration: InputDecoration(
                       hintText: "Message...",
                       hintStyle: TextStyle(
                           color: Colors.white54
                       ),
                     ),
                   )),
                   GestureDetector(
                     onTap: () {
                       sendMessage();
                     },
                     child: Container(
                         height: 40,
                         width: 40,
                         decoration: BoxDecoration(
                             gradient: LinearGradient(
                                 colors: [
                                   const Color(0x36FFFFFF),
                                   const Color(0x0FFFFFFF)
                                 ],
                                 begin: FractionalOffset.topLeft,
                                 end: FractionalOffset.bottomRight
                             ),
                             borderRadius: BorderRadius.circular(40)
                         ),
                         // padding: EdgeInsets.all(12),
                         child:
                         Icon(Icons.send)),
                   ),
                  //
                 ],
               ),
             ),
           )
          ],
        ),
      )
    );
  }
}

class MessageTile extends StatelessWidget {
final String message;
final bool isSendByMe;

MessageTile({required this.message, required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
        decoration: BoxDecoration(
          borderRadius: isSendByMe?
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ):BorderRadius.only(
            topRight: Radius.circular(23),
            topLeft: Radius.circular(23),
            bottomRight: Radius.circular(23)
          ),
          gradient: LinearGradient(
            colors: isSendByMe? [
              Colors.blue,
              Colors.blueAccent,
            ]:[
              Colors.grey,
              Colors.blueGrey,
              ]
          )
        ),
        child: Text(message,style:TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),),
      ),
    );
  }
}
