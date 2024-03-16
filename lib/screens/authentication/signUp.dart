import 'package:donact/Services/authentication_Services/mail_auth.dart';
import 'package:donact/models/association.dart';
import 'package:donact/screens/authentication/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpFormKey = GlobalKey<FormState>();
  AuthenticationService auth =
      AuthenticationService(); // Create an instance here
  Association _association = Association.empty();

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(17, 0, 0, 5),
          child: Text(
            'Email',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          validator: (val) => !EmailValidator.validate(val.toString())
              ? 'Incorrect Email'
              : null,
          onChanged: (val) {
            setState(() {
              _association.email = val;
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            hintText: 'Your e-mail',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 244, 146, 54),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildInputField({label, hint, required bool obscure, field}) {
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          validator: (val) =>
              (val == null || val == '') ? 'This field is required' : null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 244, 146, 54),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: obscure,
          onChanged: field,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildInputPhoneField({label, hint, obscure, field}) {
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          validator: (val) {
            if (val == null || val == '') {
              return 'This field is required';
            }
            if (val.toString().length != 8) {
              return 'Invalid phone number';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 244, 146, 54),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: field,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        child: Text(
          "SIGNUP",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 244, 146, 54),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: () async {
          final formStatus = _signUpFormKey.currentState;
          if (formStatus!.validate() == true) {
            Association? res =
                await auth.signUpWithEmailAndPassword(_association);
            if (res != null && res.Id.isNotEmpty) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => login()),
                (route) => false,
              );
            } else {
              // Handle sign-up failure
              print('Failed to register user');
            }
          }
        },
      ),
    );
  }

  Widget _buildFinalLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => login()),
            );
          },
          child: Text(
            "Login!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.asset('assets/logo.png'),
                ),
                Text(
                  "Create an account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
                  child: Column(
                    children: <Widget>[
                      _buildInputField(
                        label: 'Name:',
                        hint: 'Association name',
                        obscure: false,
                        field: (val) {
                          setState(() {
                            _association.name = val;
                          });
                        },
                      ),
                      _buildEmailField(),
                      _buildInputField(
                        label: 'Password:',
                        hint: '********',
                        obscure: true,
                        field: (val) {
                          setState(() {
                            _association.password = val;
                          });
                        },
                      ),
                      _buildInputPhoneField(
                        label: 'Phone number:',
                        hint: '** *** ***',
                        obscure: false,
                        field: (val) {
                          setState(() {
                            _association.phone = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _buildSignUpBtn(),
                SizedBox(height: 20),
                _buildFinalLine(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
