import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<bool> isAdmin;
  late String userId = ''; // Add this line to store the user ID

  @override
  void initState() {
    super.initState();
    // Initialize shared preferences in initState
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('Id') ?? ''; // Use the actual key you saved
      // Assuming 'Id' is the key under which user ID is stored
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          height: 25,
        ),
        backgroundColor: Color.fromARGB(255, 162, 205, 240),
      ),
      body: Row(
        children: [Text(userId)],
      ),
    );
  }
}
