import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/models/association.dart';
import 'package:donact/models/volenteer.dart';
import 'package:donact/screens/messages/displayOnechat.dart';
import 'package:donact/screens/messages/displayasso.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsList extends StatelessWidget {
  Future<String?> getAssociationIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('associationId'); // Change 'associationId' to your key
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'), // Set the title to "Messages"
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("volunteers")
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      volunteerSnapshot) {
                if (volunteerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 244, 146, 54),
                    ),
                  );
                }

                if (volunteerSnapshot.hasError) {
                  return Text('Error: ${volunteerSnapshot.error}');
                }

                if (!volunteerSnapshot.hasData ||
                    volunteerSnapshot.data!.docs.isEmpty) {
                  return Text('No volunteers available.');
                }

                return ListView.builder(
                  itemCount: volunteerSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot<Map<String, dynamic>> volunteerDoc =
                        volunteerSnapshot.data!.docs[index];
                    Volunteer volunteer =
                        Volunteer.fromMap(volunteerDoc.data()!);
                    return VolunteerItem(
                      volunteerId: volunteerDoc.id,
                      volunteer: volunteer,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<String?>(
              future: getAssociationIdFromSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 244, 146, 54),
                    ),
                  );
                }

                String? associationId = snapshot.data;

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("associations")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          associationSnapshot) {
                    if (associationSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 244, 146, 54),
                        ),
                      );
                    }

                    if (associationSnapshot.hasError) {
                      return Text('Error: ${associationSnapshot.error}');
                    }

                    if (!associationSnapshot.hasData ||
                        associationSnapshot.data!.docs.isEmpty) {
                      return Text('No associations available.');
                    }

                    List<DocumentSnapshot<Map<String, dynamic>>>
                        filteredAssociations = associationSnapshot.data!.docs
                            .where((associationDoc) =>
                                associationDoc.id != associationId)
                            .toList();

                    return ListView.builder(
                      itemCount: filteredAssociations.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot<Map<String, dynamic>> associationDoc =
                            filteredAssociations[index];
                        Association association =
                            Association.fromMap(associationDoc.data()!);
                        return AssociationItem(
                          associationId: associationDoc.id,
                          association: association,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
