import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/models/message_chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendMessage(
  String idTo,
  TextEditingController messageController,
  CollectionReference<Map<String, dynamic>> messagesCollection,
) async {
  String messageText = messageController.text.trim();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String idSender = prefs.getString('Id')!;

  if (messageText.isNotEmpty) {
    var newMessage = MessageChat(
      idFrom: idSender,
      idTo: idTo,
      timestamp: DateTime.now().toIso8601String(),
      content: messageText,
      type: 0,
    );

    messagesCollection.add(newMessage.messageToMap(newMessage));

    // Clear the message input field after sending
    messageController.clear();
  }
}
