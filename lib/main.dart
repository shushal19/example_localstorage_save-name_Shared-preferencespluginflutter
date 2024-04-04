import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: MyHome(),
  ));
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? name;
  final TextEditingController _textEditingController = TextEditingController();
  String? localUser;

  @override
  void initState() {
    super.initState();
    getUser(); // Fetch the user data when the widget initializes
  }

  getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      localUser = prefs.getString('Personname');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Name"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Name',
            ),
            controller: _textEditingController,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() async {
                name = _textEditingController.text;
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('Personname', name!);
                getUser(); // Update the displayed name after saving
              });
            },
            child: const Text('Save'),
          ),
          if (localUser != null) // Display the name if it's not null
            Text(
              'Entered Name: $localUser',
              style: const TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
