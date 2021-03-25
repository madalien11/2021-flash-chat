import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'messageBubble.dart';

class MessageStream extends StatelessWidget {
  const MessageStream({
    @required FirebaseFirestore fireStore,
    @required User loggedInUser,
  })  : _fireStore = fireStore,
        _loggedInUser = loggedInUser;

  final FirebaseFirestore _fireStore;
  final User _loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _fireStore.collection('messages').orderBy('serverTime').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'No text messages yet...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var m in messages) {
            messageBubbles.add(
              MessageBubble(
                text: m.data()['text'],
                sender: m.data()['sender'],
                isMe: _loggedInUser.email == m.data()['sender'],
              ),
            );
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        });
  }
}
