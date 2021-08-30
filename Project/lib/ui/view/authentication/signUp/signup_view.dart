import 'package:firebase_rest_api/core/model/user/user_request.dart';
import 'package:firebase_rest_api/core/services/firebase_servisces.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    var tfmail = TextEditingController();
    var tfpassword = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            customTextFormField(tfmail, false, "Mail"),
            customTextFormField(tfpassword, true, "Password"),
            ElevatedButton(
              onPressed: () async {
                try {
                  await services.SignUpEmailPassword(
                    UserRequest(email: tfmail.text, password: tfpassword.text),
                  );
                } catch (e) {
                  print("Error: $e");
                }
                setState(() {
                  tfpassword.text = "";
                  tfmail.text = "";
                });
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customTextFormField(TextEditingController tfController,
        bool passwordVisible, String labelText) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: tfController,
        obscureText: passwordVisible,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
