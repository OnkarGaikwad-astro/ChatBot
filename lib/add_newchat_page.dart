import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onkar_new_app/data/text_styles.dart';
import 'package:onkar_new_app/main.dart';
import 'package:onkar_new_app/root_page.dart';

class AddNewchatPage extends StatefulWidget {
  const AddNewchatPage({super.key});
  @override
  State<AddNewchatPage> createState() => _AddNewchatPageState();
}

TextEditingController GroupNameController = TextEditingController();
String GroupName = "";
String Profilepic = "assets/images/camera.png";

class _AddNewchatPageState extends State<AddNewchatPage> {
  File? imagefile;

  Future<void> picImageandSavepath() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        final Imagepath = picked.path;
        imagefile = File(Imagepath);
      });
      Navigator.pop(context);
    }
  }

  void AfterEnter() {
    GroupName = GroupNameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RootPage();
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),

        title: Text("Add new Chat", style: KTextStyle.timestext),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 10,
            top: 80,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Add profile image",
                        style: KTextStyle.timestext,
                      ),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            picImageandSavepath();
                          },
                          child: Text("Upload Image"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 22,
                backgroundImage: imagefile != null
                    ? FileImage(imagefile!) as ImageProvider
                    : AssetImage(Profilepic),
              ),
            ),
          ),
          Positioned(
            left: 60,
            top: 75,
            child: SizedBox(
              height: 50,
              width: 315,
              child: TextField(
                onSubmitted: (value) {
                  return AfterEnter();
                },
                controller: GroupNameController,
                decoration: InputDecoration(
                  hint: Text("Enter Group Name", style: KTextStyle.timestext),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 121,
            top: 230,
            child: ElevatedButton(
              onPressed: () {
                onCreateGroupPressed();
              },
              child: Text("Create Group"),
            ),
          ),
        ],
      ),
    );
  }

  void onCreateGroupPressed() {
    if (GroupNameController.text != "") {
      setState(() {
        if (GroupNameController.text != "") {
          AllContactNames.add(GroupNameController.text);
          filteredlist = List.from(AllContactNames);
          AllProfilePic.add(imagefile!.path);
          filteredprofilelist = List.from(AllProfilePic);

          // Save contacts
          for (int i = 0; i < AllContactNames.length; i++) {
            Hive.box("chatlistBox").put("GroupName${i}", AllContactNames[i]);
            Hive.box("profilepicBox").put("GroupName${i}", AllProfilePic[i]);
            print(Hive.box("chatlistBox").get("GroupName${i}"));
          }
          var box = Hive.box('chatlistBox');
          int itemCount = box.length;
          print("Total items in box: $itemCount");

          print(filteredlist);
        }

        GroupNameController.text = "";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RootPage();
            },
          ),
        );
      });
    }
  }
}
