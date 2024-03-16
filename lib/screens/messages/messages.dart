import 'package:donact/Services/messages/message.dart';
import 'package:donact/models/volenteer.dart';
import 'package:donact/models/association.dart';
import 'package:donact/screens/messages/MessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final Volunteer? volunteer;
  final Association? association;

  ChatScreen({this.volunteer, this.association});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final CollectionReference<Map<String, dynamic>> messagesCollection;
  late SharedPreferences prefs;
  TextEditingController _messageController = TextEditingController();
  late String userId;

  @override
  void initState() {
    super.initState();
    messagesCollection = FirebaseFirestore.instance.collection('messages');
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('Id') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.volunteer != null
              ? '${widget.volunteer!.name} ${widget.volunteer!.lastName}'
              : widget.association!.name,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: widget.volunteer != null
                  ? messagesCollection
                      .where('idFrom', isEqualTo: userId)
                      .snapshots()
                  : messagesCollection
                      .where('idTo', isEqualTo: userId)
                      .snapshots(),
              builder: (context, snapshotFrom) {
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: widget.volunteer != null
                      ? messagesCollection
                          .where('idFrom', isEqualTo: widget.volunteer!.Id)
                          .snapshots()
                      : messagesCollection
                          .where('idTo', isEqualTo: widget.association!.Id)
                          .snapshots(),
                  builder: (context, snapshotTo) {
                    if (snapshotFrom.connectionState ==
                            ConnectionState.waiting ||
                        snapshotTo.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 244, 146, 54),
                        ),
                      );
                    }

                    if (snapshotFrom.hasError || snapshotTo.hasError) {
                      return Text(
                        'Error: ${snapshotFrom.error ?? snapshotTo.error}',
                      );
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        allMessages = [];
                    if (snapshotFrom.hasData) {
                      allMessages.addAll(snapshotFrom.data!.docs);
                    }
                    if (snapshotTo.hasData) {
                      allMessages.addAll(snapshotTo.data!.docs);
                    }

                    // Sort the combined list based on timestamp or any other criteria
                    allMessages.sort((a, b) {
                      return a['timestamp'].compareTo(b['timestamp']);
                    });

                    return ListView.builder(
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot<Map<String, dynamic>> message =
                            allMessages[index];
                        bool isCurrentUser = message['idFrom'] ==
                            (widget.volunteer != null
                                ? widget.volunteer!.Id
                                : widget.association!.Id);

                        return MessageBubble(
                          timestamp: message['timestamp'],
                          content: message['content'],
                          isCurrentUser: isCurrentUser,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Input Box with Send Icon
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type your message...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => sendMessage(
                          widget.volunteer != null
                              ? widget.volunteer!.Id
                              : widget.association!.Id,
                          _messageController,
                          messagesCollection,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 223, 174),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 223, 174),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 223, 174),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
