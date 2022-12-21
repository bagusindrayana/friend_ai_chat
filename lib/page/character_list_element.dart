import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friend_ai/main.dart';
import 'package:friend_ai/model/character.dart';
import 'package:friend_ai/page/chat_room_page.dart';
import 'package:friend_ai/repository/character_repository.dart';
import 'package:friend_ai/repository/uuid_repository.dart';

class CharacterListElement extends StatefulWidget {
  final String? search;
  final SearchController? controller;
  const CharacterListElement({super.key, this.search, this.controller});

  @override
  State<CharacterListElement> createState() =>
      _CharacterListElementState(controller);
}

class _CharacterListElementState extends State<CharacterListElement> {
  _CharacterListElementState(SearchController? _controller) {
    if (_controller != null) {
      _controller.callFilter = filterSearch;
    }
  }
  List<Character> characters = [];
  List<Character> searchedCharacters = [];
  String? token;
  bool loading = false;

  void getDatas() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
    await CharacterRepository.getCharacters().then((value) {
      setState(() {
        characters = value;
        searchedCharacters = value;
      });
    });
    setState(() {
      loading = false;
    });
  }

  void getToken() async {
    setState(() {
      loading = true;
    });
    await UuidRepository.getLazyToken().then((value) {
      setState(() {
        token = value?.token;
      });
    });
    getDatas();
  }

  void filterSearch() {
    var searcheds = characters
        .where((element) =>
            (element.participantName != null &&
                element.participantName!
                    .toLowerCase()
                    .contains(widget.search!.toLowerCase())) ||
            (element.title != null &&
                element.title!
                    .toLowerCase()
                    .contains(widget.search!.toLowerCase())) ||
            (element.category != null &&
                element.category!
                    .toLowerCase()
                    .contains(widget.search!.toLowerCase())))
        .toList();
    print(searcheds.length);
    setState(() {
      searchedCharacters = searcheds;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("test");
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: RefreshIndicator(
              onRefresh: () async {
                getToken();
              },
              child: ListView.builder(
                itemCount: searchedCharacters.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title:
                          Text("${searchedCharacters[index].participantName}"),
                      subtitle: Text("${searchedCharacters[index].title}"),
                      leading: CachedNetworkImage(
                        imageUrl:
                            "https://characterai.io/i/80/static/avatars/${searchedCharacters[index].avatarFilename}",
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
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
                      onTap: (() {
                        if (token != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoomPage(
                                        character: searchedCharacters[index],
                                        token: token,
                                      )));
                        }
                      }),
                    ),
                  );
                },
              ),
            )),
        (loading)
            ? Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SizedBox(),
      ],
    );
  }
}
