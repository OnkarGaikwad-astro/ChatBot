import 'package:flutter/material.dart';
class ChatSessionPage extends StatefulWidget {
  const ChatSessionPage({super.key,required this.contact,required this.profilepic});

  final String contact;
  final String profilepic;

  @override
  State<ChatSessionPage> createState() => _ChatSessionPageState();
}

class _ChatSessionPageState extends State<ChatSessionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 55, 55, 55),
      appBar: AppBar(
        titleSpacing: -11,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.profilepic),),
            SizedBox(width: 25,),
            Text(widget.contact,style:TextStyle(fontWeight: FontWeight.w400,),),
          ],
        ),
       
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
}