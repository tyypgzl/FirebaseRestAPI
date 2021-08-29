import 'dart:io';
import 'dart:convert';
import 'package:firebase_rest_velibacik_dersi/core/model/User.dart';
import 'package:firebase_rest_velibacik_dersi/core/model/student.dart';
import 'package:firebase_rest_velibacik_dersi/core/model/user/user_auth_error.dart';
import 'package:firebase_rest_velibacik_dersi/core/model/user/user_request.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  static const FIREBASE_AUTH_URL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAGU71hgtGgFxOlWSY1x8Ju5h0sphnxqMI";
  static const FIREBASE_URL =
      "https://fir-blog-7947a-default-rtdb.europe-west1.firebasedatabase.app/";
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse("$FIREBASE_URL/users.json"),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body);
        final userList = jsonModel
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<User>();
        return userList;

      default:
        return Future.error(response.statusCode);
    }
  }

  Future postAuthLogin(UserRequest request) async {
    var jsonModel = json.encode(request.toJson());
    final response =
        await http.post(Uri.parse(FIREBASE_AUTH_URL), body: jsonModel);

    try {
      if (response.statusCode == HttpStatus.ok) {
        print("Login Succesful..");
        return true;
      } else {
        var errorJson = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorJson);
        return error;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future postStudent(Student student) async {
    var jsonModel = json.encode(student.toJson());
    try {
      final response = await http.post(
          Uri.parse(
            "$FIREBASE_URL/students.json",
          ),
          body: jsonModel);
      if (response.statusCode == 200) {
        print("Status Code:200 Succusful");
      } else {
        print("Status Code: Error${response.statusCode}");
      }
    } catch (e) {
      print("postStudent Error ErrorCode:$e");
    }
  }

  Future<List<Student>> getStudents() async {
    final response = await http.get(
      Uri.parse("$FIREBASE_URL/students.json"),
    );
    if (response.statusCode == HttpStatus.ok) {
      final jsonModel = json.decode(response.body) as Map;
      final studentList = <Student>[];
      jsonModel.forEach((key, value) {
        Student student = Student.fromJson(value);
        student.key = key;
        studentList.add(student);
      });
      return studentList;
    }
    return Future.error(response.statusCode);
  }
}
