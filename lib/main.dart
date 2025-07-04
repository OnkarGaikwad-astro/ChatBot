import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:onkar_new_app/data/notifiers.dart';
import 'package:onkar_new_app/login_page.dart';

String Your_name = "Onkar";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  await Hive.openBox('chatlistBox');
  await Hive.openBox('profilepicBox');
  await Hive.openBox('chat_${Your_name}');

  bool isDark = Hive.box('settingsBox').get('isDark', defaultValue: false);
  isDarkNotifier.value = isDark;
  runApp(MyApp());
}

List<String> AllContactNames = ["${Your_name}"];
List<String> AllProfilePic = [
  "/data/user/0/com.example.onkar_new_app/cache/129bacb3-73df-49e2-bdcf-f6ec66cd1a01/spider-man-hoodie-4k-ee5y1xior0ls1e19.jpg",
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
          AllProfilePic.add(
            Hive.box("profilepicBox").get("${AllContactNames[i]}"),
          );
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
