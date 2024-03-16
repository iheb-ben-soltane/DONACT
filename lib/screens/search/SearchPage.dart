import 'package:donact/screens/search/ProfilePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final CollectionReference volunteersRef =
      FirebaseFirestore.instance.collection('volunteers');
  final CollectionReference associationsRef =
      FirebaseFirestore.instance.collection('associations');
  final storageRef = FirebaseStorage.instance.ref();
  List<Map<String, dynamic>> volunteers = [];
  List<Map<String, dynamic>> associations = [];
  TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> _foundedUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchVolunteers();
  }

  Future<void> _fetchVolunteers() async {
    try {
      final QuerySnapshot snapshot = await volunteersRef.get();
      final QuerySnapshot asso = await associationsRef.get();
      if (snapshot.docs.isNotEmpty || asso.docs.isNotEmpty) {
        volunteers = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        associations =
            asso.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        setState(() {
          _foundedUsers = List.from(volunteers);
          _foundedUsers.addAll(associations);
        });
      } else {
        print('No volunteers found in the database');
      }
    } catch (error) {
      print('Error fetching volunteers: $error');
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    results.addAll(volunteers);
    results.addAll(associations);

    results = results
        .where((user) =>
            user['name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
    setState(() {
      _foundedUsers.clear(); // Clear the existing list
      _foundedUsers.addAll(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pathReference = storageRef.child("/volunteers/profile.png");
    print(_foundedUsers);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _controller,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        _runFilter('');
                      });
                    },
                    icon: Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 255, 223, 174)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 223,
                            174)), // Border color when the TextField is focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 223,
                            174)), // Border color when the TextField is enabled but not focused
                  ),
                  filled: true,
                  fillColor: Colors.grey[100]),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foundedUsers.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Profile(volunteer: _foundedUsers[index])),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 169, 247, 173),
                          Color.fromARGB(255, 246, 246, 246)
                        ], // Define your gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Card(
                      key: ValueKey(_foundedUsers[index]["Id"]),
                      elevation: 0, // Set elevation to 0 to remove shadow
                      color:
                          Colors.transparent, // Set card color to transparent
                      child: ListTile(
                        leading: SizedBox(
                          width: 56,
                          height: 90,
                          child: FutureBuilder<String>(
                            future: pathReference.getDownloadURL(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
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
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Align children to the ends
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the end
                                children: [
                                  (_foundedUsers[index]["name"] != null)
                                      ? Text(
                                          _foundedUsers[index]["name"],
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 4, 94, 25)),
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  (_foundedUsers[index]["location"] != null)
                                      ? Text(
                                          _foundedUsers[index]["location"],
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 4, 94, 25)),
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  (_foundedUsers[index]["phone"] != null)
                                      ? Text(
                                          _foundedUsers[index]["phone"],
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 4, 94, 25)),
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 151, 244, 156)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
