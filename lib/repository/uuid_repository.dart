import 'package:friend_ai/model/lazy.dart';
import 'package:friend_ai/provider/api_provider.dart';
import 'package:uuid/uuid.dart';

class UuidRepository {
  static const uuid = Uuid();
  static getUuid() {
    return uuid.v1();
  }

  static Future<Lazy?> getLazyToken() async {
    Lazy? lazy;
    var _uuid = getUuid();
    await ApiProvider.post(
        url: 'https://beta.character.ai/chat/auth/lazy/',
        data: {"lazy_uuid": _uuid}).then((value) {
      if (value.statusCode == 200) {
        lazy = Lazy.fromJson(value.data);
      } else {
        throw Exception('Failed to load lazy token');
      }
    });
    return lazy;
  }
}
