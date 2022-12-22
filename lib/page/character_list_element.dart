import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:friend_ai/component/character_component.dart';
import 'package:friend_ai/main.dart';
import 'package:friend_ai/model/character.dart';
import 'package:friend_ai/page/chat_room_page.dart';
import 'package:friend_ai/provider/database_provider.dart';
import 'package:friend_ai/provider/storage_provider.dart';
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
    await StorageProvider.getLocalToken().then((value) {
      if (value != null) {
        setState(() {
          token = value;
        });
      }
    });
    if (token == null) {
      await UuidRepository.getLazyToken().then((value) async {
        if (value != null && value.token != null) {
          setState(() {
            token = value.token;
          });
          await StorageProvider.setTempToken(value.token!);
        }
      });
    }
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
    print(widget.search);
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
              child: (searchedCharacters.length <= 0)
                  ? ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No character found"),
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: searchedCharacters.length,
                      itemBuilder: (context, index) {
                        return CharacterComponent(
                            char: searchedCharacters[index],
                            onTap: () {
                              if (token != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatRoomPage(
                                              character:
                                                  searchedCharacters[index],
                                              token: token,
                                            )));
                              }
                            });
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
