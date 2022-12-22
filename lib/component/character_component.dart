import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:friend_ai/model/character.dart';

class CharacterComponent extends StatefulWidget {
  final Character char;
  final Function onTap;
  const CharacterComponent(
      {super.key, required this.char, required this.onTap});

  @override
  State<CharacterComponent> createState() => _CharacterComponentState();
}

class _CharacterComponentState extends State<CharacterComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${widget.char.participantName}"),
        subtitle: Text("${widget.char.title}"),
        leading: CachedNetworkImage(
          imageUrl:
              "https://characterai.io/i/80/static/avatars/${widget.char.avatarFilename}",
          imageBuilder: (context, imageProvider) => Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            height: 80,
            width: 80,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        onTap: () {
          widget.onTap();
        },
      ),
    );
  }
}
