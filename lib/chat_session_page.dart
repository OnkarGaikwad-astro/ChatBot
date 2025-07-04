import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

TextEditingController Msgcontroller = TextEditingController();

String bgimage = "";
bool send = false;
Color containerColor = Colors.teal;
List<Widget> Messages = [];
List<Widget> msgdisplay = [];
List<String> temp_message = [];
String Reply = "";
String prompt = "";
late int boxlength;
late String name;

const String apiKey =
    "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";

Future<String> getDeepSeekReply(String prompt) async {
  final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "model": "deepseek/deepseek-chat-v3-0324:free",
      "messages": [
        {"role": "user", "content": prompt},
      ],
      "stream": false,
    }),
  );
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
  return "❌ Error ${response.statusCode}: ${response.reasonPhrase}";
}

class ChatSessionPage extends StatefulWidget {
  const ChatSessionPage({
    super.key,
    required this.contact,
    required this.profilepic,
  });

  final String contact;
  final String profilepic;

  @override
  State<ChatSessionPage> createState() => _ChatSessionPageState();
}

class _ChatSessionPageState extends State<ChatSessionPage> {
  File? imagefile;
  void flash() async {
    setState(() {
      containerColor = const Color.fromARGB(0, 255, 255, 255);
    });
    await Future.delayed(Duration(milliseconds: 100));
    setState(() => containerColor = Colors.teal);
  }

  void removebg() async {
    await Hive.box(
      "settingsBox",
    ).delete("bgimage_${widget.contact.toLowerCase()}");
    imagefile = null;
    setState(() {});
  }

  void bgimagepicker() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imagefile = File(picked.path);
      await Hive.box(
        "settingsBox",
      ).put("bgimage_${widget.contact.toLowerCase()}", imagefile!.path);
      setState(() {});
    }
  }

  Widget setbgimage() {
    final defaultImage = Hive.box("settingsBox").get("isDark") == true
        ? "assets/images/image.png"
        : "assets/images/image copy.png";
    return Image(
      image: imagefile != null
          ? FileImage(imagefile!)
          : AssetImage(defaultImage) as ImageProvider,
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    super.initState();
    name = widget.contact.toLowerCase();
    setbgimage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeChat();
    });
  }

  Future<void> initializeChat() async {
    final boxName = "chat_${widget.contact.toLowerCase()}";
    name = widget.contact.toLowerCase();

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }

    final chatBox = Hive.box(boxName);
    boxlength = chatBox.length;

    // Load messages
    for (int i = 0; i < boxlength; i++) {
      temp_message.add(chatBox.get("message_$i"));
    }

    final imagePath = Hive.box("settingsBox").get("bgimage_${name}");
    if (imagePath != null) {
      imagefile = File(imagePath);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: const Color.fromARGB(255, 45, 56, 55),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Set Background Image"),
                onTap: bgimagepicker,
              ),
              PopupMenuItem(
                child: Text("Remove Background Image"),
                onTap: () {
                  removebg();
                  setbgimage();
                },
              ),
              PopupMenuItem(
                child: Text("Clear Chats"),
                onTap: () {
                  Hive.box("chat_${widget.contact.toLowerCase()}").clear();
                  temp_message = [];
                  setState(() {});
                },
              ),
              PopupMenuItem(child: Text("Onkar")),
            ],
          ),
        ],
        titleSpacing: -11,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: FileImage(File(widget.profilepic))),
            SizedBox(width: 25),
            Text(widget.contact, style: TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: setbgimage()),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  SizedBox(width: double.infinity, height: 600),

                  display(),

                  SizedBox(width: double.infinity, height: 150),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 16,
            child: Container(
              decoration: ShapeDecoration(
                color: const Color.fromARGB(255, 101, 101, 101),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(30),
                ),
              ),
              height: 50,
              width: 300,
              child: TextField(
                
                controller: Msgcontroller,
                decoration: InputDecoration(
                  suffixIcon: Transform.rotate(
                    angle: 3.14 / 2,
                    child: Icon(Icons.attachment_outlined),
                  ),
                  suffixIconColor: Colors.white,
                  prefixIcon: Icon(Icons.emoji_emotions_outlined),
                  prefixIconColor: Colors.white,
                  hintText: "Message",
                  hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 17,
            child: Container(
              height: 45,
              width: 45,
              child: GestureDetector(
                onTap: () async {
                  if (Msgcontroller.text.trim().isNotEmpty) {
                  if (Msgcontroller.text.trim().isNotEmpty) {
                    temp_message.add(" ${Msgcontroller.text}");
                  }
                  prompt = Msgcontroller.text;
                  send = true;
                  flash();
                  setState(() {});
                  await Future.delayed(Duration(seconds: 1));
                  Reply = await getDeepSeekReply(prompt);
                  if (Reply != "") {
                    temp_message.add(Reply);
                  }
                  // Reply = "";
                  setState(() {});}
                },
                child: CircleAvatar(
                  backgroundColor: containerColor,
                  child: Icon(Icons.send_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /////// Sended msg display  //////

  Widget sendedmsg(String value) {
    Widget sendedmsg = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 200,
            minHeight: 30,
            minWidth: 50,
          ),

          // height: 40,
          // width: 175,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: const Color.fromARGB(255, 13, 13, 13),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "You",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 144, 104, 214),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(6),
                child: Text(
                  value,
                  style: TextStyle(
                    color: const Color.fromARGB(218, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // send = false;
    Msgcontroller.text = "";
    return sendedmsg;
  }

  ////// recieved msg display //////

  Widget recievedmsg(String value) {
    Widget recievedmsg = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 200,
            minHeight: 30,
            minWidth: 50,
          ),

          // height: 40,
          // width: 175,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: const Color.fromARGB(255, 13, 13, 13),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Deepseek",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 144, 104, 214),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(6),
                child: Text(
                  value,
                  style: TextStyle(
                    color: const Color.fromARGB(218, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
    return recievedmsg;
  }

  ///////    main display fn      //////

  Widget display() {
    msgdisplay.clear();
    Widget displaymsg = SizedBox.shrink();
    for (int i = 0; i < temp_message.length; i++) {
      Hive.box(
        "chat_${widget.contact.toLowerCase()}",
      ).put("message_${i}", temp_message[i]);
      if (temp_message[i][0] == " ") {
        displaymsg = sendedmsg(temp_message[i]);
      } else {
        displaymsg = recievedmsg(temp_message[i]);
      }
      msgdisplay.add(displaymsg);
    }
    print(temp_message);
    return Column(children: msgdisplay);
  }
}
