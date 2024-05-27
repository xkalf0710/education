import 'dart:convert';

import 'package:education/model/user.dart';
import 'package:education/model/user_name.dart';
import 'package:education/model/users_dob.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<List<User>> fetchUsers() async{
    const url ="https://randomuser.me/api/?results=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    final users = results.map((e) {
      final name = UserName(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last']);
      final date = e['dob']['date'];
      final dob = UsersDob(date:DateTime.parse(date), age: e['dob']['age']);
      return User(
        cell: e['cell'],
        email: e['email'],
        gender: e['gender'],
        nat: e['nat'],
        phone: e['phone'],
        name: name,
        dob: dob,
      );

    }).toList();

    return users;
  }
}


