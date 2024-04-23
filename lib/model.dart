// person.dart
class Person {
  int id;
  String name;
  int age;
  String mobileNo;
  String email;

  Person({required this.id, required this.name, required this.age, required this.mobileNo, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'mobileNo': mobileNo,
      'email': email,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      mobileNo: map['mobileNo'],
      email: map['email'],
    );
  }
}