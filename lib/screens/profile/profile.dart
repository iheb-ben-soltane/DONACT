import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/Services/authentication_Services/mail_auth.dart';
import 'package:donact/screens/authentication/login.dart';
import 'package:donact/screens/profile/settingScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId = '';

  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    loadUserIdFromSharedPreferences();
    super.initState();
  }

  Future<String> loadUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   userId = prefs.getString('Id') ?? "";
    // });
    return prefs.getString('Id') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final pathReference = storageRef.child("/volunteers/profile.png");

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadUserIdFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Center(
                      child: CircularProgressIndicator(
                color: Color.fromARGB(255, 244, 146, 54),
              )));
            }
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 50),
                      FutureBuilder<String>(
                        future: pathReference.getDownloadURL(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 244, 146, 54),
                            ));
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error loading image: ${snapshot.error}');
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
                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('associations')
                        .doc(snapshot.data as String)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                            child: Center(
                                child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 244, 146, 54),
                        )));
                      }

                      Map<String, dynamic> associationData =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 60),
                            buildProfileItem(
                              'Association Name',
                              associationData['name'] ?? '',
                              'name',
                              context,
                            ),
                            SizedBox(height: 20),
                            buildProfileItem(
                              'Association Email',
                              associationData['email'] ?? '',
                              'email',
                              context,
                            ),
                            SizedBox(height: 20),
                            buildProfileItem(
                              'Association Phone Number',
                              associationData['phone'] ?? '',
                              'phone',
                              context,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 244, 146, 54),
            ));
          }),
    );
  }

  void _handleLogout() async {
    bool success = await AuthenticationService().logout();
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } else {
      print('Logout failed');
    }
  }

  Widget buildProfileItem(
      String title, String value, String field, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FieldUpdateScreen(title: title, field: field)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 223, 174),
                Color.fromARGB(255, 246, 246, 246)
              ], // Define your gradient colors
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 189, 105, 2),
                      ),
                    ),
                  ),
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
