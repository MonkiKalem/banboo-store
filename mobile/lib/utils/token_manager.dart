import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  // Singleton instance  
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  // Kunci untuk menyimpan token  
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';

  // Inisialisasi FlutterSecureStorage  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Simpan token  
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Ambil token  
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Hapus token (logout)  
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }

  // Simpan User ID  
  Future<void> saveUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  // Ambil User ID  
  Future<int?> getUserId() async {
    final userIdString = await _storage.read(key: _userIdKey);
    return userIdString != null ? int.tryParse(userIdString) : null;
  }

  // Cek apakah sudah login  
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}