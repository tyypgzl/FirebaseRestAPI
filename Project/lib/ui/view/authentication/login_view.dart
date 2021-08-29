import 'package:firebase_rest_velibacik_dersi/core/model/user/user_auth_error.dart';
import 'package:firebase_rest_velibacik_dersi/core/model/user/user_request.dart';
import 'package:firebase_rest_velibacik_dersi/core/services/firebase_services.dart';
import 'package:firebase_rest_velibacik_dersi/ui/view/home/fire_home.dart';
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
              TextFormField(
                controller: tfUsername,
                decoration: InputDecoration(
                  labelText: "Username",
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: tfPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(250, 40),
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
                          MaterialPageRoute(
                              builder: (context) => FireHomeView()),
                          (route) => false);
                    }
                  } catch (e) {
                    print("********************");
                    print(e.toString());
                  }
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
