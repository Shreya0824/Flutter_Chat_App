import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/conversation_screen.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods.getuserByUsername(searchTextEditingController.text)
          .then((snapshot) {
        searchSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }}

    Widget searchList() {
      return haveUserSearched ? ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapshot.docs.length,
          itemBuilder: (context, index) {
            return SearchTile(userEmail: searchSnapshot.docs[index]["email"],
                userName: searchSnapshot.docs[index]["name"]);
          })
          : Container();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Search username...",
                        hintStyle: TextStyle(
                            color: Colors.white54
                        ),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        initiateSearch();
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
                          Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              searchList(),
            ],
          ),
        ),
      );
    }
  }
createChatRoomAndStartConversation(BuildContext context ,String userName){
  if(Constants.myName!=userName){
print("${Constants.myName}lllllllllllllllllllllll");
  String chatRoomId= getChatRoomId(userName,Constants.myName);
  List<String> users = [userName,Constants.myName];
  Map<String, dynamic> chatRoomMap = {
    "users": users,
    "chatRoomId" : chatRoomId,
  };
  DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId:chatRoomId)));
}
}

class SearchTile extends StatelessWidget {
final String userName;
final String userEmail;
SearchTile({required this.userEmail,required this.userName});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(userName, style: simpleTextFieldStyle(),),
                  Text(userEmail, style: simpleTextFieldStyle(),),

                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                createChatRoomAndStartConversation(context,userName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: Text("Message"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
