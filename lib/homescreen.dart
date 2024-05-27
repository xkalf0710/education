
import 'package:education/model/user.dart';
import 'package:education/services/user_api.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rest Api Call"),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            // final color = user.gender == 'male' ? Colors.blue : Colors.red;
            return ListTile(
              title: Text(user.fullName),
              subtitle: Text(user.phone),
            );
          }),

    );
  }
  Future<void> fetchUsers() async{
    final response = await UserApi.fetchUsers();

    setState(() {
      users = response;
    });
  }
}