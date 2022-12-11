import 'package:dio/dio.dart';
import 'package:friend_ai/model/character.dart';
import 'package:friend_ai/model/charcater_detail.dart';
import 'package:friend_ai/provider/api_provider.dart';

class CharacterRepository {
  //get dio https://beta.character.ai/chat/categories/characters/
  static Future<List<Character>> getCharacters() async {
    final response = await ApiProvider.get(
        url: 'https://beta.character.ai/chat/categories/characters/');
    List<Character> datas = [];
    if (response.statusCode == 200) {
      final result = response.data['characters_by_category'];

      result.forEach((final String key, final value) {
        for (var char in result[key]) {
          var new_c = char;
          new_c['category'] = key;
          datas.add(Character.fromJson(new_c));
        }
      });
      // for (var characters in result) {
      //   print(characters);
      //   for (var char in characters) {
      //     datas.add(Character.fromJson(char));
      //   }
      // }
      return datas;
    } else {
      throw Exception('Failed to load characters');
    }
  }

  static Future<CharacterDetail> getCharacter(String id, String token) async {
    final response = await ApiProvider.post(
        url: 'https://beta.character.ai/chat/character/info/',
        data: {
          'external_id': id
        },
        header: {
          'authorization': "Token $token",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 200) {
      return CharacterDetail.fromJson(response.data['character']);
    } else {
      throw Exception('Failed to load character');
    }
  }
}
