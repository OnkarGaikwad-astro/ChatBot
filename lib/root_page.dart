import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:onkar_new_app/add_newchat_page.dart';
import 'package:onkar_new_app/chat_page.dart';
import 'package:onkar_new_app/data/notifiers.dart';
import 'package:onkar_new_app/settings_page.dart';

int SelectedPage = 0;
List<Widget> Pages = [ChatPage()];
bool isDark = true;

class RootPage extends StatefulWidget {
  const RootPage({super.key, required});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBot", style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDarkNotifier.value = !isDarkNotifier.value;
                Hive.box('settingsBox').put('isDark', isDarkNotifier.value);
              });
            },
            icon: isDarkNotifier.value
                ? Icon(Icons.dark_mode)
                : Icon(Icons.light_mode),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingsPage();
                      },
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: Text("Delete All Contacts"),
                onTap: () {
                  Clearchatlist();
                },
              ),
              PopupMenuItem(child: Text("Item 3")),
              PopupMenuItem(child: Text("Item 4")),
              PopupMenuItem(child: Text("Item 5")),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(20),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: NavigationBar(
      //   destinations: [
      //     NavigationDestination(
      //       icon: Icon(Icons.message_rounded),
      //       label: "Chats",
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.groups_outlined),
      //       label: "Communities",
      //     ),
      //   ],
      //   onDestinationSelected: (value) {
      //     setState(() {
      //       SelectedPage = value;
      //     });
      //   },
      //   selectedIndex: SelectedPage,
      // ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add new",
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddNewchatPage();
              },
            ),
          );
        },
        child: Icon(Icons.add_box),
        backgroundColor: const Color.fromARGB(255, 90, 200, 93),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Pages[SelectedPage],
    );
  }

  void Clearchatlist() async {
    var box = Hive.box('chatlistBox');
    await box.clear();
  }
}
