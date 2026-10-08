import '../providers/messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di.dart';
import 'message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = locator<FirebaseAuth>();
    final authUser = firebaseAuth.currentUser!;
    return StreamBuilder(
      stream: ref.watch(messagesProvider.notifier).getMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Messages Found.'));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong....'));
        }
        final loadedMessage = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(13, 0, 13, 30),
          reverse: true,
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessage[index].data();
            final nextMessage = index + 1 < loadedMessage.length
                ? loadedMessage[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userid'];
            final nextMessageUserId = nextMessage != null
                ? nextMessage['userid']
                : null;

            final bool nextUserIsSame =
                nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
