import 'package:flutter/material.dart';
import 'package:friend_ai/page/login_charcater_ai_page.dart';

class ChatHistoryElement extends StatefulWidget {
  const ChatHistoryElement({super.key});

  @override
  State<ChatHistoryElement> createState() => _ChatHistoryElementState();
}

class _ChatHistoryElementState extends State<ChatHistoryElement> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Login to see your chat history"),
        ElevatedButton(
          onPressed: () {
            //InAppWebViewExampleScreen
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginCharacterAiPage()));
          },
          child: const Text('Login Character AI'),
        )
      ],
    ));
  }
}
