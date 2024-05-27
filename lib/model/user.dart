import 'package:education/model/user_location.dart';
import 'package:education/model/user_name.dart';
import 'package:education/model/user_picture.dart';
import 'package:education/model/users_dob.dart';

class User {
  final String gender;
  final String email;
  final String phone;
  final String cell;
  final String nat;
  final UserName name;
  final UsersDob dob;
  final UserLocation location;
  final UserPicture picture;
  User({
    required this.gender,
    required this.email,
    required this.phone,
    required this.cell,
    required this.nat,
    required this.name,
    required this.dob,
    required this.location,
    required this.picture,
});

  factory User.fromMap(Map<String, dynamic> e) {

      final name = UserName.fromMap(e['name']);

      final dob = UsersDob.fromMap(e['dob']);
      final location = UserLocation.fromMap(e['location']);
      final picture = UserPicture.fromMap(e['picture']);
      return User(
        cell: e['cell'],
        email: e['email'],
        gender: e['gender'],
        nat: e['nat'],
        phone: e['phone'],
        name: name,
        dob: dob,
        location: location,
        picture: picture,
      );

  }

  String get fullName {
    return '${name.title} ${name.first} ${name.last}';
  }
}

