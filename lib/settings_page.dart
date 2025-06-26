import 'package:flutter/material.dart';
import 'package:onkar_new_app/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            Navigator.pop(context,MaterialPageRoute(builder: (context) {
              return LoginPage();
            },));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return LoginPage();
              
            },));
          }, child: Text("Logout !"))
        ],
      ),
    );
  }
}