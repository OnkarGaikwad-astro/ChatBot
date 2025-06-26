import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:onkar_new_app/add_members.dart';
import 'package:onkar_new_app/data/text_styles.dart';
import 'package:onkar_new_app/main.dart';
import 'package:onkar_new_app/root_page.dart';

class AddNewchatPage extends StatefulWidget {
  const AddNewchatPage({super.key});
  @override
  State<AddNewchatPage> createState() => _AddNewchatPageState();
}

TextEditingController ProfilePicLinkController = TextEditingController();
TextEditingController GroupNameController = TextEditingController();
String GroupName = "";
String profilepiclink =
    "https://www.creativefabrica.com/wp-content/uploads/2019/02/Camera-icon-by-ahlangraphic-27-312x208.jpg";

class _AddNewchatPageState extends State<AddNewchatPage> {
  void AfterEnter() {
    GroupName = GroupNameController.text;
  }

  void ProfilePic() {
    profilepiclink = ProfilePicLinkController.text;
    ProfilePicLinkController.text = "";
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Image Link",
                                    style: KTextStyle.timestext,
                                  ),
                                  content: TextField(
                                    controller: ProfilePicLinkController,
                                    onSubmitted: (value) {
                                      return setState(() {
                                        profilepiclink =
                                            ProfilePicLinkController.text;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hint: Text(
                                        "Enter Image Link",
                                        style: KTextStyle.timestext,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                );
                              },
                            );
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
                backgroundImage: NetworkImage(profilepiclink),
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
          Positioned(top: 160,left: 120,child: TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddMembers();
            },));
          }, child: Row(children: [Text("Add Members "),Icon(Icons.keyboard_double_arrow_right_outlined)],),)),
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
          AllProfilePic.add(ProfilePicLinkController.text);
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
          profilepiclink =
              "https://www.creativefabrica.com/wp-content/uploads/2019/02/Camera-icon-by-ahlangraphic-27-312x208.jpg";

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
