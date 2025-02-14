import 'package:hive/hive.dart';

part 'token.g.dart';

@HiveType(typeId: 0)
class TokenModel extends HiveObject {
  @HiveField(0)
  String accessToken;

  @HiveField(1)
  String refreshToken;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
  });

  // Create TokenModel from JSON
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }

  // Convert TokenModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}