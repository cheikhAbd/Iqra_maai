import 'package:hive/hive.dart';

part 'otp.g.dart';

@HiveType(typeId: 7)
class OtpVerification {
  @HiveField(0)
  int id;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String otpCode;

  @HiveField(3)
  DateTime expiry;

  OtpVerification({
    this.id = 0,
    this.phone = '',
    this.otpCode = '',
    DateTime? expiry,
  }) : expiry = expiry ?? DateTime.now().add(const Duration(minutes: 5));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'otp_code': otpCode,
      'expiry': expiry.toIso8601String(),
    };
  }

  factory OtpVerification.fromMap(Map<String, dynamic> map) {
    return OtpVerification(
      id: map['id']?? 0,
      phone: map['phone'] ?? '',
      otpCode: map['otp_code'] ?? '',
      expiry: DateTime.tryParse(map['expiry'] ?? '') ?? DateTime.now().add(const Duration(minutes: 5)),
    );
  }
}