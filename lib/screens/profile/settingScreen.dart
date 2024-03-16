import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FieldUpdateScreen extends StatefulWidget {
  final String title;
  final String field;

  const FieldUpdateScreen({required this.title, required this.field});

  @override
  _FieldUpdateScreenState createState() => _FieldUpdateScreenState();
}

class _FieldUpdateScreenState extends State<FieldUpdateScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update ${widget.title}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              label: widget.title,
              hint: widget.field,
              obscur: false,
              onChanged: (value) {
                setState(() {
                  _controller.text = value;
                });
              },
            ),
            UpdateBTN(context, widget.title, _controller.text),
          ],
        ),
      ),
    );
  }

  Widget UpdateBTN(BuildContext context, String field, String newValue) {
    return Container(
      height: 40,
      child: ElevatedButton(
        child: Text(
          "  UPDATE  ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 242, 192, 92),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: () async {
          String Field = 'phone';
          if (field == 'Association Name')
            Field = 'name';
          else if (field == 'Association Email') Field = 'email';
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String userId = prefs.getString('Id') ?? "";
            if (userId.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('associations')
                  .doc(userId)
                  .update({Field: newValue});

              Navigator.pop(
                  context); // Pop the current screen off the navigation stack
            }
          } catch (e) {
            print('Error updating field: $e');
          }
        },
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscur;
  final ValueChanged<String> onChanged;

  const InputField({
    required this.label,
    required this.hint,
    required this.obscur,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(17, 0, 0, 5),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        TextFormField(
          validator: (val) {
            if (val == null || val == '') {
              return 'you need to fill this field!';
            }
            return null;
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 242, 192, 92), width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: obscur,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
