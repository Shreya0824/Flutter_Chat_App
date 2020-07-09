import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, chatroomid) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatroomid)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatroomid) async{
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatroomid)
        .collection("chats")
        .orderBy('time',descending: false)
        .snapshots();
  }


  Future<void> addMessage(String chatroomid, chatMessageData){

    Firestore.instance.collection("ChatRoom")
        .document(chatroomid)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}