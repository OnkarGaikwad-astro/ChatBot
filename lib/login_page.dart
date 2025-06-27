import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onkar_new_app/root_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    Positioned(left: 25,bottom: 5,child: Text("ChatBot",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,fontFamily: "Times New Roman"),))
                  ],
                ),
              ),
              SizedBox(
                height: 75,
              ),
              Lottie.asset("assets/lotties/welcome.json"),
              SizedBox(
                height: 75,
              ),
              ElevatedButton(onPressed: () {
                
              }, child:Text("Login with Google")),
              SizedBox(height: 20,child: Text("or"),),
              ElevatedButton(onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return RootPage();
                },));
              }, child: Text("Skip"))
            ],
          ),
        ),
      ),
    );
  }
}