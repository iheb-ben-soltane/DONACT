import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/Services/messages/message.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ActivityDetailsScreen extends StatelessWidget {
  final String activityName;
  final String activityDate;
  final String activityLocation;
  final String activityDescription;
  final String associationId; // Add associationId field
  TextEditingController _messageController = TextEditingController();

  ActivityDetailsScreen({
    required this.activityName,
    required this.activityDate,
    required this.activityLocation,
    required this.activityDescription,
    required this.associationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDetailItem('Name', activityName),
            _buildDetailItem('Date', activityDate),
            _buildDetailItem('Location', activityLocation),
            _buildDetailItem('Description', activityDescription),
            SizedBox(height: 16),
            _buildInterestedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
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
  }

  Widget _buildInterestedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showInterestedPopup(context);
      },
      child: Text(
        '  Interested  ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _showInterestedPopup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedAssociationId = prefs.getString('associationId') ?? '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 48,
          ),
          content: Text('You are now interested in this activity.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (storedAssociationId != associationId) {
                  _messageController.text = "we want to invite you to join us!";
                  sendMessage(
                    associationId,
                    _messageController,
                    FirebaseFirestore.instance.collection('messages'),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
