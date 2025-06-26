import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:onkar_new_app/data/notifiers.dart';
import 'package:onkar_new_app/login_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  await Hive.openBox('chatlistBox');
  await Hive.openBox('profilepicBox');

  bool isDark = Hive.box('settingsBox').get('isDark', defaultValue: false);
  isDarkNotifier.value = isDark;
  runApp(MyApp());
}

List<String> AllContactNames = ["Onkar"];
List<String> AllProfilePic = [
  "https://th.bing.com/th/id/OIP.HiZNuArVyBkOZGKR7v_eBgHaHa?w=626&h=626&rs=1&pid=ImgDetMain",
];
List filteredprofilelist = [];
List filteredlist = [];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Retrive allcontactnames and profilepics
    var box = Hive.box('chatlistBox');
    int boxlength = box.length;
    for (int i = 0; i < boxlength; i++) {
      if (Hive.box("chatlistBox").get("GroupName${i}") != null) {
        if (!AllContactNames.contains(
          Hive.box("chatlistBox").get("GroupName${i}"),
        )) {
          AllContactNames.add(Hive.box("chatlistBox").get("GroupName${i}"));
          AllProfilePic.add(Hive.box("profilepicBox").get("GroupName${i}"));
        }
      }
    }

    filteredlist = List.from(AllContactNames);
    filteredprofilelist = List.from(AllProfilePic);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            canvasColor: Colors.green,
          ),
          home: LoginPage(),
        );
      },
    );
  }
}
