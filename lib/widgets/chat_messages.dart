import 'message_bubble.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = firebaseAuth.currentUser!;
    return StreamBuilder(
      stream:
          firebaseFirestore
              .collection('chat')
              .orderBy('createAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Messages Found.'));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong .....'));
        }
        final loadedMessage = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(13, 0, 13, 30),
          reverse: true,
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessage[index].data();
            final nextMessage =
                index + 1 < loadedMessage.length
                    ? loadedMessage[index + 1].data()
                    : null;

            final currentMessageUserId = chatMessage['userid'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userid'] : null;

            final bool nextUserIsSame =
                nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
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
