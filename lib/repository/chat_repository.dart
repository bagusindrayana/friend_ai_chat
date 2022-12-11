import 'package:dio/dio.dart';
import 'package:friend_ai/model/message.dart';
import 'package:friend_ai/provider/api_provider.dart';

class ChatRepository {
  static Future<String?> createChat(String id, String token) async {
    String? result;
    try {
      await ApiProvider.post(
          url: "https://beta.character.ai/chat/history/create/",
          data: {
            "character_external_id": id,
            "override_history_set": null
          },
          header: {
            "authorization": "Token $token",
            "Content-Type": "application/json"
          }).then((value) {
        if (value.statusCode == 200) {
          result = value.data['external_id'] ?? null;
        }
      });
    } catch (e) {
      if (e is DioError) {
        print(e.response);
      } else {
        print(e);
      }
    }

    return result;
  }

  static Future<String?> continueChat(String id, String token) async {
    String? result;
    print(id);
    print(token);
    try {
      await ApiProvider.post(
          url: "https://beta.character.ai/chat/history/continue/",
          data: {
            "character_external_id": id
          },
          header: {
            "authorization": "Token $token",
            "Content-Type": "application/json"
          }).then((value) {
        print(value);
        if (value.statusCode == 200) {
          result = value.data['external_id'] ?? null;
        }
      });
    } catch (e) {
      if (e is DioError) {
        print(e.response);
      } else {
        print(e);
      }
    }

    return result;
  }

  static Future<List<Message>> getMessage(
      String historyId, String token) async {
    List<Message> datas = [];
    try {
      final response = await ApiProvider.get(
          url:
              "https://beta.character.ai/chat/history/msgs/user/?history_external_id=$historyId",
          header: {
            "authorization": "Token $token",
            "Content-Type": "application/json"
          });

      if (response.statusCode == 200) {
        final result = response.data['messages'];
        for (var message in result) {
          datas.add(Message.fromJson(message));
        }
        return datas;
      }
    } catch (e) {
      print(e);
    }
    return datas;
  }

  static Future<dynamic?> streamMessage(String id, String historyId,
      String token, String text, String tgt) async {
    var result;
    try {
      await ApiProvider.post(
          url: "https://beta.character.ai/chat/streaming/",
          data: {
            "history_external_id": historyId,
            "character_external_id": id,
            "text": text,
            "tgt": tgt,
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
          header: {
            "authorization": "Token $token",
            "Content-Type": "application/json"
          }).then((value) {
        result = value.data;
      });
    } catch (e, s) {
      print(e);
      if (e is DioError) {
        print(e.response?.statusCode);
      }
    }
    return result;
  }
}
