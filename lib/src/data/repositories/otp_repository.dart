import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/otp.dart';

class OtpVerificationRepository {
  static const String boxName = 'otp_verifications';

  Future<Box<OtpVerification>> get _box async => await Hive.openBox<OtpVerification>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(OtpVerificationAdapter());
    }
  }

  // Create
  Future<OtpVerification> create(OtpVerification otpVerification) async {
    final box = await _box;
    await box.put(otpVerification.id, otpVerification);
    return otpVerification;
  }

  // Read
  Future<OtpVerification?> get(int id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<OtpVerification>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<OtpVerification> update(OtpVerification otpVerification) async {
    final box = await _box;
    await box.put(otpVerification.id, otpVerification);
    return otpVerification;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  // Custom queries
  // Future<OtpVerification?> findByPhone(String phone) async {
  //   final box = await _box;
  //   return box.values.firstWhere(
  //     (otp) => otp.phone == phone,
  //     orElse: () => null,
  //   );
  // }

  // Future<void> deleteExpired() async {
  //   final box = await _box;
  //   final now = DateTime.now();
  //   final expiredOtps = box.values.where((otp) => otp.expiry.isBefore(now));
    
  //   for (var otp in expiredOtps) {
  //     await box.delete(otp.id);
  //   }
  // }
}