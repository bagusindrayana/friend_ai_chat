import 'package:dio/dio.dart';
import 'package:friend_ai/model/category.dart';
import 'package:friend_ai/provider/api_provider.dart';

class CategoryRepository {
  static Future<List<Category>> getCategories(String token) async {
    List<Category> chars = [];

    try {
      await ApiProvider.get(
          url: 'https://beta.character.ai/chat/character/categories/',
          header: {"authorization": "Token $token"}).then((value) {
        if (value.statusCode == 200 &&
            value.data['categories'] != null &&
            value.data['categories'].length > 0) {
          for (var i = 0; i < value.data['categories'].length; i++) {
            var char = value.data['categories'][i];
            chars.add(Category.fromJson(char));
          }
        } else {
          throw Exception('Failed to load category');
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
}
