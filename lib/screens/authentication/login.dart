import 'package:donact/Services/authentication_Services/mail_auth.dart';
import 'package:donact/constants/constants.dart';
import 'package:donact/models/association.dart';
import 'package:donact/screens/app.dart';
import 'package:donact/screens/authentication/forgetPass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'signUp.dart';

bool validateMail(String mail) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(mail);
  return emailValid;
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  AuthenticationService auth = AuthenticationService();
  final _SignInFomKey = GlobalKey<FormState>();
  ValueNotifier<UserCredential?> userCredential = ValueNotifier(null);
  String email = '';
  String pass = '';
  String err = '';
  bool showPassword = true;
  @override
  void initState() {
    //  AuthenticationService().logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    toastMsg(String msg, BuildContext theContext) {
      ScaffoldMessenger.of(theContext).showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        elevation: 15,
        backgroundColor: Color.fromARGB(255, 244, 146, 54),
      ));
    }

    //final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
    /*   final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>(); */

    // RegExp exp = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');
    submitLog(String mail, String pass, BuildContext theContext) async {
      if (_SignInFomKey.currentState!.validate() == true) {
        // _formKey.currentState!.save();
        try {
          Association? res = await AuthenticationService()
              .loginWithEmailAndPassword(email, pass);
          print(res);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            toastMsg("e-mail adresse not found !", theContext);
          } else if (e.code == 'wrong-password') {
            toastMsg("incorrect password !", theContext);
          }
        }
      }
    }

    Size size = MediaQuery.of(context).size;

    Widget InputField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (val) => (val == null || !validateMail(val.toString()))
                ? 'Email format incorect'
                : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              hintText: "association@mail.tn",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 244, 146, 54), width: 3.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red, width: 3.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            onChanged: (value) {
              setState(() => email = value);
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    Widget InputPassField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (val) => (val == null || val.length < 6)
                ? 'the password should have at least six characers. '
                : null,
            obscureText: showPassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              hintText: 'password',
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  (showPassword) ? Icons.visibility_off : Icons.visibility,
                  color: kBlackColor,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 244, 146, 54), width: 3.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red, width: 3.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() => pass = value);
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    Widget SignInBTN(BuildContext cntx) {
      return Container(
          height: 40,
          width: size.width * 0.5,
          child: ElevatedButton(
            child: Text(
              "LOGIN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 242, 192, 92),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            onPressed: () async {
              final formStatus = _SignInFomKey
                  .currentState; // Change _signUpFormKey to _SignInFomKey
              if (formStatus!.validate() == true) {
                Association? res =
                    await auth.loginWithEmailAndPassword(email, pass);

                if (res != null) {
                  // Login successful, navigate to the desired screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => App()),
                    (route) => false,
                  );
                } else {
                  // Handle login failure
                  print('Failed to login');
                }
              }
            },
          )
          /* RaisedButton(
          elevation: 5,
          onPressed: () async {
            submitLog(email, pass, cntx);
          },
          padding: EdgeInsets.all(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.red,
          child: Text(
            "SE CONNECTER",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ), */
          );
    }

    Widget FinalLine() {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("you don't have an account ? "),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Text(
            "create one ! ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ]);
    }

    Widget forgetPass() {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => ForgotPassword()));
          },
          child: Text(
            "have you forgot your password ? ",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        )
      ]);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _SignInFomKey,
            child: Column(
              children: <Widget>[
                Container(
                  width: size.width * 0.9,
                  child: Image.asset('assets/logo.png'),
                ),
                Text(
                  "Welcome !",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "login to continue",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(
                    children: [
                      InputField(),
                      SizedBox(
                        height: 10,
                      ),
                      InputPassField(),
                      SizedBox(
                        height: 30,
                      ),
                      SignInBTN(context),
                      /*    SizedBox(
                        height: 20,
                      ), */
                      Text(
                        err,
                        style: TextStyle(
                            color: Color.fromARGB(255, 244, 146, 54),
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                forgetPass(),
                FinalLine(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
