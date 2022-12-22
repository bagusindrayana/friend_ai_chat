import 'package:flutter/material.dart';
import 'package:friend_ai/component/character_component.dart';
import 'package:friend_ai/model/character.dart';
import 'package:friend_ai/model/user.dart';
import 'package:friend_ai/page/chat_room_page.dart';
import 'package:friend_ai/page/login_charcater_ai_page.dart';
import 'package:friend_ai/provider/storage_provider.dart';
import 'package:friend_ai/repository/user_repository.dart';
import 'package:friend_ai/utility/utility_helper.dart';

class ChatHistoryElement extends StatefulWidget {
  const ChatHistoryElement({super.key});

  @override
  State<ChatHistoryElement> createState() => _ChatHistoryElementState();
}

class _ChatHistoryElementState extends State<ChatHistoryElement> {
  String? token;
  User? user;
  List<Character> chars = [];
  void getUser() async {
    UtilityHelper.showAlertDialogLoading(
        context, "Loading...", "Autentikasi user...");
    await StorageProvider.getLocalToken().then((value) async {
      if (value != null) {
        token = value;
        await UserRepository.getUser(value).then((_user) {
          setState(() {
            user = _user;
          });
          getChatHistory();
        });
      }
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (user != null) {
      UtilityHelper.showSnackBar(context, "Hello ${user!.username}");
    }
  }

  void getChatHistory() async {
    if (token != null) {
      await UserRepository.getChatHistory(token!).then((_chars) {
        setState(() {
          chars = _chars;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (user == null)
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login to see your chat history"),
              ElevatedButton(
                onPressed: () {
                  //InAppWebViewExampleScreen
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => LoginCharacterAiPage()))
                      .then((value) {
                    setState(() {
                      getUser();
                    });
                  });
                },
                child: const Text('Login Character AI'),
              )
            ],
          ))
        : RefreshIndicator(
            onRefresh: () async {
              getChatHistory();
            },
            child: (chars.length <= 0)
                ? ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("No chat history"),
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: chars.length,
                    itemBuilder: (context, index) {
                      return CharacterComponent(
                          char: chars[index],
                          onTap: () {
                            if (token != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoomPage(
                                            character: chars[index],
                                            token: token,
                                          ))).then((value) => getChatHistory());
                            }
                          });
                    },
                  ),
          );
  }
}
