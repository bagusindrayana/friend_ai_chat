import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:friend_ai/model/message.dart';

class MessageComponent extends StatefulWidget {
  final Message message;
  const MessageComponent({super.key, required this.message});

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  String printex = "";
  int idx = 0;

  void typeEffect() {
    Future.delayed(Duration(milliseconds: 50), () {
      if (widget.message.text != "" && widget.message.text!.length > idx) {
        setState(() {
          printex += "${widget.message.text![idx]}";
          //widget.message.text = widget.message.text!.substring(1);
          idx++;
        });
      }

      if (widget.message.animated == true ||
          widget.message.text!.length > idx) {
        typeEffect();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message.animated == true) {
      typeEffect();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper1(
          type: (widget.message.srcName == "Guest")
              ? BubbleType.sendBubble
              : BubbleType.receiverBubble),
      alignment: (widget.message.srcName == "Guest")
          ? Alignment.topRight
          : Alignment.topLeft,
      margin: EdgeInsets.only(top: 20),
      backGroundColor:
          (widget.message.srcName == "Guest") ? Colors.blue : Colors.grey[200],
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: (widget.message.animated == true)
            ? Text("${printex}")
            : Text("${widget.message.text}"),
      ),
    );
  }
}
