import 'package:flutter/material.dart';
import 'package:onkar_new_app/chat_widget.dart';
import 'package:onkar_new_app/main.dart';

TextEditingController SearchController = TextEditingController();
String SearchBarText = "Search chats";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    filteredlist = List.from(AllContactNames);
    filteredprofilelist = List.from(AllProfilePic);
    super.initState();
  }

  void searchfilter(String text) {
    setState(() {
      filteredlist = AllContactNames.where(
        (contact) => contact.toLowerCase().contains(text.toLowerCase()),
      ).toList();

      List<int> matchedIndices = AllContactNames.asMap().entries
          .where(
            (entry) => entry.value.toLowerCase().contains(text.toLowerCase()),
          )
          .map((entry) => entry.key)
          .toList();
      filteredprofilelist = [];
      for (int i = 0; i < matchedIndices.length; i++) {
        filteredprofilelist.add(AllProfilePic[matchedIndices[i]]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              onChanged: searchfilter,
              controller: SearchController,
              decoration: InputDecoration(
                filled: true,
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                hintText: SearchBarText,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredlist.length,
              itemBuilder: (context, index) {
                final contact = filteredlist[index];
                final profilepic = filteredprofilelist[index];
                return ChatWidget(profilepic: profilepic, contact: contact);
              },
            ),
          ),
        ],
      ),
    );
  }
}
