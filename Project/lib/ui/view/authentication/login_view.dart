import 'package:firebase_rest_api/core/model/user/user_auth_errror.dart';
import 'package:firebase_rest_api/core/model/user/user_request.dart';
import 'package:firebase_rest_api/core/services/firebase_servisces.dart';
import 'package:firebase_rest_api/core/services/google_signin_services.dart';
import 'package:firebase_rest_api/ui/view/home/fire_home_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var tfUsername = TextEditingController();
    var tfPassword = TextEditingController();
    FirebaseServices services = FirebaseServices();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customTextFormField(tfUsername, false, "Username"),
              emptySizedBox(),
              customTextFormField(tfPassword, true, "Password"),
              emptySizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  loginButton(services, tfUsername, tfPassword, context),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(130, 40),
                    ),
                    onPressed: () async {
                      var data = await GoogleSignHelper.instance.signIn();
                      if (data != null) {
                        var userData =
                            await GoogleSignHelper.instance.googleAuthtentice();
                        print(userData);
                      }
                    },
                    child: Text("Google Login"),
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

Widget customTextFormField(TextEditingController tfController,
        bool passwordVisible, String labelText) =>
    TextFormField(
      controller: tfController,
      obscureText: passwordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

Widget emptySizedBox() => SizedBox(
      height: 20,
    );

Widget loginButton(FirebaseServices services, TextEditingController tfUsername,
        TextEditingController tfPassword, BuildContext context) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: Size(130, 40),
      ),
      onPressed: () async {
        try {
          var result = await services.postAuthLogin(
            UserRequest(
                email: tfUsername.text,
                password: tfPassword.text,
                returnSecureToken: true),
          );
          if (result is FirebaseAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 1),
                content: Text(result.error!.message.toString()),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 1),
                content: Text("User Login Succesful"),
              ),
            );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => FireHomeView()),
                (route) => false);
          }
        } catch (e) {
          print("********************");
          print(e.toString());
        }
      },
      child: Text("Login"),
    );
