import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final String timestamp;
  final bool isCurrentUser;

  MessageBubble({
    required this.content,
    required this.timestamp,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    String timestampString = timestamp;
    DateTime dateTime = DateTime.parse(timestampString);
    String formattedString = DateFormat('MM/dd \'AT\' HH:mm').format(dateTime);
    return Container(
      alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(formattedString),
              SizedBox(height: 4.0),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}
