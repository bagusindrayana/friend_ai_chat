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
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    return datas;
  }
}
