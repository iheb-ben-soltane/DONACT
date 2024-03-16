import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/models/activity.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NewActivity extends StatefulWidget {
  @override
  _NewActivityFormState createState() => _NewActivityFormState();
}

class _NewActivityFormState extends State<NewActivity> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;
  Activity _Activity = Activity.empty();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1935, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange, // Header background color
            hintColor: Colors.orange, // Color of buttons
            colorScheme: ColorScheme.light(primary: Colors.orange),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _Activity.date = picked.toString().substring(0, 10);
        print(_Activity.date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget DatePicker() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                "    Date: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  _selectDate(context);
                },
                icon: Icon(
                  Icons.calendar_today,
                  color: Color.fromARGB(255, 242, 192, 92),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(selectedDate.toString().substring(0, 10)),
            ),
          ),
        ],
      );
    }

    Widget InputField({label, hint, required bool obscur, field}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 0, 5),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
              validator: (val) {
                if (val == null || val == '') {
                  return 'you need to fill this field!';
                }

                return null;
              },
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
              onChanged: field
              //  (val) {
              //   setState(() {
              //     _agentCrt.phone = val;
              //   });
              //   print(field);
              // },
              ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    void _resetForm() {
      _formKey.currentState?.reset();
      setState(() {
        selectedDate = DateTime.now();
      });
    }

    Widget ADDBTN() {
      return Container(
        height: 40,
        width: size.width * 0.5,
        child: ElevatedButton(
          child: Text(
            "ADD ACTIVITY",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          onPressed: () async {
            final formstatus = _formKey.currentState;
            prefs = await SharedPreferences.getInstance();
            _Activity.associationId = prefs.getString('Id')!;

            if (formstatus!.validate() == true) {
              // Create a new document in Firestore and get its reference
              DocumentReference docRef = await _firestore
                  .collection('activities')
                  .add(_Activity.toMap());

              // Set the id of the Activity to the document ID
              _Activity.id = docRef.id;

              // Update the document with the Activity including its ID
              await docRef.set(_Activity.toMap());

              // Reset the form fields
              _resetForm();
              print("act added successfully");
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add activity",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
                  child: Column(
                    children: <Widget>[
                      InputField(
                          label: 'Name:',
                          hint: 'activity name',
                          obscur: false,
                          field: (val1) {
                            setState(() {
                              _Activity.name = val1;
                            });
                          }),
                      InputField(
                          label: 'Description:',
                          hint: 'description of the activity',
                          obscur: false,
                          field: (val2) {
                            setState(() {
                              _Activity.description = val2;
                            });
                          }),
                      InputField(
                          label: 'Location:',
                          hint: 'location of the activity',
                          obscur: false,
                          field: (val3) {
                            setState(() {
                              _Activity.location = val3;
                            });
                          }),
                      DatePicker(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                ADDBTN(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
