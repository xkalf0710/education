class UsersDob {
  final DateTime date;
  final int age;

  UsersDob({
    required this.date,
    required this.age
});
  factory UsersDob.fromMap(Map<String, dynamic> json) {
    return UsersDob(date: DateTime.parse(json['date']), age: json['age']);
  }
}