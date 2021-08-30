import 'package:firebase_rest_api/core/model/student.dart';
import 'package:firebase_rest_api/core/model/user.dart';
import 'package:firebase_rest_api/core/services/firebase_servisces.dart';
import 'package:firebase_rest_api/ui/view/authentication/signIn/signin_view.dart';
import 'package:flutter/material.dart';

class FireHomeView extends StatefulWidget {
  @override
  _FireHomeViewState createState() => _FireHomeViewState();
}

class _FireHomeViewState extends State<FireHomeView> {
  var tfName = TextEditingController();
  var tfNumber = TextEditingController();
  FirebaseServices services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //  GoogleSignHelper.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInView()),
                  (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: studentFutureBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 0,
                backgroundColor: Colors.white60,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                title: Text(
                  "Add Student",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: tfName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: tfNumber,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          elevation: 0,
                          minimumSize: Size(150, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () async {
                        try {
                          await FirebaseServices().postStudent(Student(
                              name: tfName.text,
                              number: int.parse(tfNumber.text)));
                        } catch (e) {
                          print("post Student button Hatası, Error:$e");
                        }
                        tfName.text = "";
                        tfNumber.text = "";
                        Navigator.pop(context);
                      },
                      child: Text("Add"),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget studentFutureBuilder() => FutureBuilder<List<Student>>(
        future: services.getStudents(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                return _listStudent(snapshot.data);
              } else
                return _notFoundWidget();

            default:
              return _waitingWidget();
          }
        },
      );

  Widget userFutureBuilder() => FutureBuilder<List<User>>(
        future: services.getUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                return _listUser(snapshot.data);
              } else
                return _notFoundWidget();

            default:
              return _waitingWidget();
          }
        },
      );

  Widget _listUser(List<User>? list) {
    return ListView.builder(
      itemCount: list!.length,
      itemBuilder: (context, index) {
        return _userCard(list[index]);
      },
    );
  }

  Widget _listStudent(List<Student>? list) {
    return ListView.builder(
      itemCount: list!.length,
      itemBuilder: (context, index) {
        return _studentCard(list[index]);
      },
    );
  }

  Widget _userCard(User user) {
    return Card(
      child: ListTile(
        title: Text(user.name.toString()),
      ),
    );
  }

  Widget _studentCard(Student student) {
    return Card(
      child: ListTile(
        title: Text(student.name.toString()),
        subtitle: Text(student.number.toString()),
      ),
    );
  }

  Widget _notFoundWidget() => Center(
        child: Text("Veriye Ulaşmada sorun yaşandı"),
      );
  Widget _waitingWidget() => Center(
        child: CircularProgressIndicator(),
      );
}
