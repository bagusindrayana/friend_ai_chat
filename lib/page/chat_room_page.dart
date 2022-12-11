import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friend_ai/component/message_component.dart';
import 'package:friend_ai/model/character.dart';
import 'package:friend_ai/model/charcater_detail.dart';
import 'package:friend_ai/model/message.dart';
import 'package:friend_ai/repository/character_repository.dart';
import 'package:friend_ai/repository/chat_repository.dart';
import 'package:friend_ai/utility/utility_helper.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ChatRoomPage extends StatefulWidget {
  final Character? character;
  final String? token;
  const ChatRoomPage({super.key, this.character, this.token});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  CharacterDetail? characterDetail;
  bool loading = false;
  List<Message> messages = [];
  String? historyId;
  final whitespaceRE = RegExp(r"(?! )\s+| \s+");

  List<AnimatedTextKit> replieAnimatedTextKit = [];
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();
  void getCharacterDetail() async {
    setState(() {
      loading = true;
    });
    await CharacterRepository.getCharacter(
            "${widget.character?.externalid}", "${widget.token}")
        .then((value) {
      setState(() {
        characterDetail = value;
      });
      if (characterDetail?.participantUserUsername != null) {
        getChatHistory();
      }
    });
  }

  void getChatHistory() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }

    await ChatRepository.continueChat(
            "${widget.character?.externalid}", "${widget.token}")
        .then((value) async {
      if (value != null) {
        setState(() {
          historyId = value;
        });
      } else {
        await ChatRepository.createChat(
                "${widget.character?.externalid}", "${widget.token}")
            .then((v) {
          setState(() {
            historyId = v;
          });
        });
      }
    });

    if (historyId != null) {
      await ChatRepository.getMessage(historyId!, "${widget.token}")
          .then((value) {
        setState(() {
          messages = value;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          }
        });
      });
    }
    setState(() {
      loading = false;
    });
  }

  void sendMessage() async {
    var msg = null;
    setState(() {
      loading = true;
      messages.add(Message(text: msgController.text, srcName: "Guest"));
      msg = msgController.text;
      Future.delayed(Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
      msgController.text = "";
    });
    if (msg == null) {
      return;
    }
    Response<ResponseBody> rs;
    rs = await Dio().post<ResponseBody>(
      "https://beta.character.ai/chat/streaming/",
      data: {
        "history_external_id": historyId,
        "character_external_id": widget.character?.externalid,
        "text": msg,
        "tgt": characterDetail?.participantUserUsername,
        "ranking_method": "random",
        "staging": false,
        "model_server_address": null,
        "override_prefix": null,
        "override_rank": null,
        "rank_candidates": null,
        "filter_candidates": null,
        "prefix_limit": null,
        "prefix_token_limit": null,
        "livetune_coeff": null,
        "stream_params": null,
        "enable_tti": true,
        "initial_timeout": null,
        "insert_beginning": null,
        "translate_candidates": null,
        "stream_every_n_steps": 16,
        "chunks_to_pad": 8,
        "is_proactive": false,
        "image_rel_path": "",
        "image_description": "",
        "image_description_type": "",
        "image_origin_type": "",
        "voice_enabled": false
      },

      options: Options(responseType: ResponseType.stream, headers: {
        "authorization": "Token ${widget.token}",
        "Content-Type": "application/json"
      }), // set responseType to `stream`
    );
    StreamTransformer<Uint8List, List<int>> unit8Transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );
    rs.data?.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        // .transform(const SseTransformer())
        .listen((event) {
      var r = null;
      try {
        r = jsonDecode(event);
      } catch (e) {}
      print(r);
      if (r != null) {
        if (r['force_login'] != null && r['force_login'] == true) {
          UtilityHelper.showAlertDialog(context, "Anda harus login",
              "Please login to continue use this service");
        }

        if (r['replies'] != null && r['replies'].length > 0) {
          r['replies'][0]['text'] = r['replies'][0]['text'].trim();
          if (r['replies'][0]['text'] != "") {
            bool found = false;
            for (var x = 0; x < messages.length; x++) {
              if (r['replies'][0]['text']?.contains(messages[x].text) &&
                  messages[x].srcName != "Guest") {
                found = true;
                var old_text = messages[x].text;
                var new_text = r['replies'][0]['text'];
                setState(() {
                  messages[x].text = new_text;
                  messages[x].animated = (r['is_final_chunk'] == false &&
                      r['is_final_chunk'] != null);
                  // var t_p =
                  //     TypewriterAnimatedText(new_text.replaceAll(old_text, ""));
                  // messages[x].animatedTextKits?.add(AnimatedTextKit(
                  //       repeatForever: false,
                  //       totalRepeatCount: 1,
                  //       animatedTexts: [t_p],
                  //     ));
                });
              }
            }
            if (!found) {
              setState(() {
                messages.add(Message(
                    animated: true,
                    text: r['replies'][0]['text'],
                    srcName: "${r['src_char']['participant']['name']}",
                    animatedTextKits: [
                      AnimatedTextKit(
                        repeatForever: false,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(r['replies'][0]['text']),
                        ],
                      )
                    ]));
              });
            }
          }
        }
      }
      Future.delayed(Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
      Future.delayed(Duration(milliseconds: 500), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    });

    // await ChatRepository.streamMessage(
    //         "${widget.character?.externalid}",
    //         "${historyId}",
    //         "${widget.token}",
    //         msgController.text,
    //         "${characterDetail?.participantUserUsername}")
    //     .then((value) {
    //   setState(() {
    //     replies = value;
    //     print(replies['replies']);
    //     for (var r in replies['replies']) {
    //       messages.add(
    //           Message(text: r['text'], srcName: replies['src_char']['name']));
    //     }
    //     Future.delayed(Duration(milliseconds: 100), () {
    //       scrollController.animateTo(
    //         scrollController.position.maxScrollExtent,
    //         curve: Curves.easeOut,
    //         duration: const Duration(milliseconds: 300),
    //       );
    //     });
    //   });
    // });
    setState(() {
      loading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCharacterDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://characterai.io/i/80/static/avatars/${widget.character?.avatarfilename}",
                imageBuilder: (context, imageProvider) => Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(width: 20),
              Text("${widget.character?.participantname}"),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 70,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (messages[index].isAlternative == true &&
                        messages[index].srcName != "Guest") {
                      return SizedBox();
                    }
                    if (index == messages.length - 1 && loading) {
                      return Column(
                        key: ValueKey(index.toString()),
                        children: [
                          MessageComponent(message: messages[index]),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: 50,
                                height: 15,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,

                                  /// Required, The loading type of the widget
                                  colors: const [Colors.blue],

                                  /// Optional, The color collections
                                  strokeWidth: 0.5,

                                  /// Optional, The stroke of the line, only applicable to widget which contains line /// Optional, the stroke backgroundColor
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return MessageComponent(
                          key: ValueKey(index.toString()),
                          message: messages[index]);
                    }
                  },
                )),
            (loading && messages.length == 0)
                ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          sendMessage();
                        },
                        controller: msgController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        sendMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
