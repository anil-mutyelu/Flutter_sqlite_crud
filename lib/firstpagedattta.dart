import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db_data.dart';
import 'model.dart';


class MyHomePage11231 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage11231> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Person> _persons = [];
  Person? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _refreshPersons();
  }

  _refreshPersons() async {
    List<Person> persons = await _databaseHelper.getAllPersons();
    setState(() {
      _persons = persons;
    });
  }

  _clearControllers() {
    _nameController.clear();
    _ageController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _selectedPerson = null;
  }

  _onSubmit() async {
    Person person = Person(
      id: _selectedPerson?.id ?? 0,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      mobileNo: _mobileNoController.text,
      email: _emailController.text,
    );

    if (_selectedPerson == null) {
      await _databaseHelper.insertPerson(person);
    } else {
      await _databaseHelper.updatePerson(person);
    }

    _clearControllers();
    _refreshPersons();
  }

  _onDelete(int id) async {
    await _databaseHelper.deletePerson(id);
    _clearControllers();
    _refreshPersons();
  }

  _onEdit(Person person) {
    _nameController.text = person.name;
    _ageController.text = person.age.toString();
    _mobileNoController.text = person.mobileNo;
    _emailController.text = person.email;
    setState(() {
      _selectedPerson = person;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite CRUD Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _mobileNoController,
                    decoration: InputDecoration(labelText: 'Mobile Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Persons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _persons.map((person) {
                return ListTile(
                  title: Text(person.name),
                  subtitle: Text('Age: ${person.age}, Mobile: ${person.mobileNo}, Email: ${person.email}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _onEdit(person),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _onDelete(person.id),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}