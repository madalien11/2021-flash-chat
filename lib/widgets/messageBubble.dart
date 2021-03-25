import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: isMe ? 5 : 0,
              left: isMe ? 0 : 5,
            ),
            child: Text(
              sender.replaceRange(sender.indexOf('@'), sender.length, ''),
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topRight: isMe ? Radius.circular(0) : Radius.circular(30),
                topLeft: isMe ? Radius.circular(30) : Radius.circular(0),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: isMe ? Colors.amberAccent : Colors.grey[800],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.black : Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
