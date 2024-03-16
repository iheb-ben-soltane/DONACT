import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/Services/messages/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> volunteer;

  Profile({Key? key, required this.volunteer}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final Map<String, dynamic> volunteer;
  final storageRef = FirebaseStorage.instance.ref();
  final CollectionReference<Map<String, dynamic>> messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController _messageController = TextEditingController();
  String _buttonText = "+ Invite";
  Color _buttonColor = Colors.orange;
  bool _isButtonClickable = true;

  @override
  void initState() {
    super.initState();
    volunteer = widget.volunteer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              padding: EdgeInsetsDirectional.only(start: 10),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 35,
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
            ),
          ],
        ),
        title: Text(
          volunteer["lastName"] != null
              ? "${volunteer["name"]} ${volunteer["lastName"]} details"
              : "${volunteer["name"]} details",
        ),
        centerTitle: true,
        // Other app bar properties
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _showProfileImage("/volunteers/profile.png"),
              _buildDetailItem('Name', volunteer["name"]),
              _buildDetailItem('Last Name', volunteer["lastName"]),
              _buildDetailItem('Email', volunteer["email"]),
              _buildDetailItem('Location', volunteer["location"]),
              _buildDetailItem('Phone Number', volunteer["phone"]),
              _buildDetailItem('BirthDay', volunteer["birthDate"]),
              SizedBox(height: 8),
              _buildInterestedButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    if (value != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 223, 174),
              Color.fromARGB(255, 246, 246, 246)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 189, 105, 2),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Return an empty container if value is null
    }
  }

  Widget _buildInterestedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isButtonClickable
          ? () {
              _messageController.text = "we want to invite you to join us!";
              sendMessage(
                volunteer["Id"],
                _messageController,
                FirebaseFirestore.instance.collection('messages'),
              );

              // Update button text and color
              setState(() {
                _buttonText = "pending..";
                _buttonColor = Color.fromARGB(255, 215, 215, 255);
                _isButtonClickable = false;
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Your invitation has been sent. Waiting for acceptance.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: Text(
        _buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _showProfileImage(String path) {
    final pathReference = storageRef.child(path);
    return Container(
      width: 180,
      height: 180,
      child: FutureBuilder<String>(
        future: pathReference.getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading image: ${snapshot.error}');
          } else {
            String imageUrl = snapshot.data ?? '';
            return ClipOval(
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
              ),
            );
          }
        },
      ),
    );
  }
}
