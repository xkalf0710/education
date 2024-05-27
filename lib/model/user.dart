import 'package:education/model/user_name.dart';
import 'package:education/model/users_dob.dart';

class User {
  final String gender;
  final String email;
  final String phone;
  final String cell;
  final String nat;
  final UserName name;
  final UsersDob dob;
  User({
    required this.gender,
    required this.email,
    required this.phone,
    required this.cell,
    required this.nat,
    required this.name,
    required this.dob,
});

  String get fullName {
    return '${name.title} ${name.first} ${name.last}';
  }
}

