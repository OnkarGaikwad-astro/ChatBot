import 'dart:io';
import 'package:flutter/material.dart';
import 'package:onkar_new_app/chat_session_page.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.profilepic,
    required this.contact,
  });

  final String profilepic;
  final String contact;
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatSessionPage(
                contact: widget.contact,
                profilepic: widget.profilepic,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(3, 255, 255, 255),
          ),
          height: 50,
          width: 200,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.file(
                        File(widget.profilepic),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 62,
                child: Text(
                  widget.contact,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              Positioned(
                left: 64,
                top: 25,
                child: Text(
                  "Chats between you and ${widget.contact}",
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
