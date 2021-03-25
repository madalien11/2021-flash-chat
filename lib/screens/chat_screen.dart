import 'welcome_screen.dart';
import '../constants.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User loggedInUser;
  String messageText;

  void _getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void _getMessages() async {
  //   final messages = await _fireStore.collection('messages').get();
  //   for (var m in messages.docs) {
  //     print(m.data());
  //   }
  // }

  void _messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots())
      for (var m in snapshot.docs) {
        print(m.data());
      }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _messagesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(WelcomeScreen.id));
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                _auth.signOut();
                Navigator.popUntil(
                    context, ModalRoute.withName(WelcomeScreen.id));
              }),
        ],
        title: Text('⚡️Chat'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'No text messages yet...',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  final messages = snapshot.data.docs;
                  List<Text> messageWidgets = [];
                  for (var m in messages) {
                    messageWidgets.add(
                      Text('${m.data()['text']} from ${m.data()['sender']}'),
                    );
                  }
                  return Column(
                    children: messageWidgets,
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _fireStore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': messageText,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
