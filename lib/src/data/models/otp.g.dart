// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OtpVerificationAdapter extends TypeAdapter<OtpVerification> {
  @override
  final int typeId = 7;

  @override
  OtpVerification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OtpVerification(
      id: fields[0] as int,
      phone: fields[1] as String,
      otpCode: fields[2] as String,
      expiry: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OtpVerification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.otpCode)
      ..writeByte(3)
      ..write(obj.expiry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtpVerificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
