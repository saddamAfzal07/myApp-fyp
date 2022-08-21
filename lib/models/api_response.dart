import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiResponse {
  Object? data;
  String? error;
  final storage = const FlutterSecureStorage();
  final keyToken = 'token';

  storeToken(String token) async {
    await storage.write(key: keyToken, value: token);
  }

  getToken() async {
    return await storage.read(key: keyToken);
  }

  getExpense() {}
}
