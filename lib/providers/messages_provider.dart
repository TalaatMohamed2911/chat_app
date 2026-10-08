import 'package:chat_app/di.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

class MessagesProvider extends StateNotifier<Map<String, dynamic>> {
  final firebaseFirestore = locator<FirebaseFirestore>();
  final firebaseAuth = locator<FirebaseAuth>();
  MessagesProvider() : super({});

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage() {
    return firebaseFirestore
        .collection('chat')
        .orderBy('createAt', descending: true)
        .snapshots();
  }

  void sendMessage(String message) async {
    final enteredMessage = message;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    final User? user = firebaseAuth.currentUser;

    final DocumentSnapshot<Map<String, dynamic>> userData =
        await firebaseFirestore.collection('users').doc(user?.uid).get();

    await firebaseFirestore.collection('chat').add({
      'text': enteredMessage,
      'createAt': Timestamp.now(),
      'userid': user?.uid,
      'username': userData.data()?['username'],
      'userImage': userData.data()?['image_url'],
    });
  }
}

final StateNotifierProvider<MessagesProvider, Map<String, dynamic>>
messagesProvider = StateNotifierProvider((ref) => MessagesProvider());
