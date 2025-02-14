import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/token.dart';

class TokenRepository {
  static const String boxName = 'tokens';

  Future<Box<TokenModel>> get _box async => await Hive.openBox<TokenModel>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(TokenModelAdapter());
    }
  }

  // Save tokens
  Future<void> saveTokens(TokenModel tokens) async {
    final box = await _box;
    await box.put('userTokens', tokens);
  }

  // Get tokens
  Future<TokenModel?> getTokens() async {
    final box = await _box;
    return box.get('userTokens');
  }

  // Get access token
  Future<String?> getAccessToken() async {
    final tokens = await getTokens();
    return tokens?.accessToken;
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    final tokens = await getTokens();
    return tokens?.refreshToken;
  }

  // Update access token
  Future<void> updateAccessToken(String newAccessToken) async {
    final box = await _box;
    final tokens = await getTokens();
    if (tokens != null) {
      tokens.accessToken = newAccessToken;
      await box.put('userTokens', tokens);
    }
  }

  // Delete tokens (logout)
  Future<void> deleteTokens() async {
    final box = await _box;
    await box.delete('userTokens');
  }

  // Check if tokens exist
  Future<bool> hasTokens() async {
    final tokens = await getTokens();
    return tokens != null;
  }
}