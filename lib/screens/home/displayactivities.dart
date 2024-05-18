import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:donact/screens/home/activitydetails.dart';

class DisplayTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'), // Set the title to "Activities"
      ),
      body: ActivitiesList(),
    );
  }
}

class ActivitiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("activities").snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 244, 146, 54),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No activities available.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot<Map<String, dynamic>> activityDoc =
                snapshot.data!.docs[index];
            String activityName = activityDoc['name'];
            String activityDate = activityDoc['date'];
            String activityLocation = activityDoc['location'];
            String activityDescription = activityDoc['description'];
            String associationId = activityDoc['associationId'];
            return ActivityItem(
              activityName: activityName,
              activityDate: activityDate,
              activityLocation: activityLocation,
              activityDescription: activityDescription,
              associationId: associationId,
            );
          },
        );
      },
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String activityName;
  final String activityDate;
  final String activityLocation;
  final String activityDescription;
  final String associationId;

  ActivityItem({
    required this.activityName,
    required this.activityDate,
    required this.activityLocation,
    required this.activityDescription,
    required this.associationId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ActivityDetailsScreen on card click
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailsScreen(
              activityName: activityName,
              activityDate: activityDate,
              activityLocation: activityLocation,
              activityDescription: activityDescription,
              associationId: associationId,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 223, 174),
                Color.fromARGB(255, 246, 246, 246)
              ], // Define your gradient colors
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.event,
                size: 40.0,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityName,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 252, 131, 1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date: $activityDate',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(height: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 248, 192, 108),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
