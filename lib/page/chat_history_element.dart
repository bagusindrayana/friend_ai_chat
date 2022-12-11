import 'package:flutter/material.dart';

class ChatHistoryElement extends StatefulWidget {
  const ChatHistoryElement({super.key});

  @override
  State<ChatHistoryElement> createState() => _ChatHistoryElementState();
}

class _ChatHistoryElementState extends State<ChatHistoryElement> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Chat History"),
    );
  }
}
