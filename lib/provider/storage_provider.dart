import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageProvider {
  static Future<String?> getLocalToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: "char_token");
  }

  static Future<String?> getTempToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: "token");
  }

  static setTempToken(String token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "token", value: token);
  }

  static deleteAll() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
  }
}
