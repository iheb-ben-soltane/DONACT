import 'package:donact/models/association.dart';
import 'package:donact/screens/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AssociationItem extends StatelessWidget {
  final String associationId;
  final Association association;
  final storageRef = FirebaseStorage.instance.ref();

  AssociationItem({
    required this.associationId,
    required this.association,
  });

  @override
  Widget build(BuildContext context) {
    final pathReference = storageRef.child(association.profilePicture);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              association: association,
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
                Color.fromARGB(255, 169, 247, 173),
                Color.fromARGB(255, 246, 246, 246)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: pathReference.getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 244, 146, 54),
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Error loading image: ${snapshot.error}');
                  } else {
                    String imageUrl = snapshot.data ?? '';
                    return ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 70,
                        height: 70,
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    association.name,
                    style: TextStyle(
                        fontSize: 15.0, color: Color.fromARGB(255, 4, 94, 25)),
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
