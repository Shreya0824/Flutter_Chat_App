import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  getuserByUsername(String username)async{
return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get();
  }

  getuserByUserEmail(String userEmail)async{
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: userEmail).get();
  }
  Future<void> uploadUserInfo(userMap)async{
await FirebaseFirestore.instance.collection("users").add(userMap);
}
createChatRoom(String chatroomId,chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatroomId).set(chatRoomMap);
}

 addConversationMessages(String chatRoomId,messageMap)async {
   await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messageMap);
}
  getConversationMessages(String chatRoomId) async{
   return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").orderBy("time").snapshots();
  }
  getChatRooms(String userName)async{
    return await FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: userName).snapshots();
  }
}