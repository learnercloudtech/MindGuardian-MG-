// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodLogAdapter extends TypeAdapter<MoodLog> {
  @override
  final int typeId = 0;

  @override
  MoodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodLog(
      moodScore: fields[0] as int,
      note: fields[1] as String,
      timestamp: fields[2] as DateTime,
      emotion: fields[3] as String?,
      agentReply: fields[4] as String?,
      riskScore: fields[5] as int?,
      recommendations: (fields[6] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoodLog obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.moodScore)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.emotion)
      ..writeByte(4)
      ..write(obj.agentReply)
      ..writeByte(5)
      ..write(obj.riskScore)
      ..writeByte(6)
      ..write(obj.recommendations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
