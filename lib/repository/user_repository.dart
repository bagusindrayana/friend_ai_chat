import 'package:dio/dio.dart';
import 'package:friend_ai/model/character.dart';
import 'package:friend_ai/model/user.dart';

import 'package:friend_ai/provider/api_provider.dart';

class UserRepository {
  static Future<User?> getUser(String token) async {
    User? user;

    try {
      await ApiProvider.get(
          url: 'https://beta.character.ai/chat/user/',
          header: {"authorization": "Token $token"}).then((value) {
        if (value.statusCode == 200 && value.data['user'] != null) {
          user = User.fromJson(value.data['user']['user']);
        } else {
          throw Exception('Failed to load user');
        }
      });
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data);
      } else {
        print(e);
      }
    }
    return user;
  }

  static Future<List<Character>> getChatHistory(String token) async {
    List<Character> chars = [];

    try {
      await ApiProvider.get(
          url: 'https://beta.character.ai/chat/characters/recent/',
          header: {"authorization": "Token $token"}).then((value) {
        if (value.statusCode == 200 &&
            value.data['characters'] != null &&
            value.data['characters'].length > 0) {
          for (var i = 0; i < value.data['characters'].length; i++) {
            var char = value.data['characters'][i];
            chars.add(Character.fromJson(char));
          }
        } else {
          throw Exception('Failed to load hisotry');
        }
      });
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data);
      } else {
        print(e);
      }
    }
    return chars;
  }

  static Future<bool> deleteChatHistory(String token, String char_id) async {
    bool result = false;

    try {
      await ApiProvider.post(
          url: 'https://beta.character.ai/chat/history/hide/',
          data: {"character_external_id": char_id},
          header: {"authorization": "Token $token"}).then((value) {
        if (value.statusCode == 200 &&
            value.data['status'] != null &&
            value.data['status'] != "Ok") {
          result = true;
        } else {
          throw Exception('Failed to load user');
        }
      });
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data);
      } else {
        print(e);
      }
    }
    return result;
  }
}
