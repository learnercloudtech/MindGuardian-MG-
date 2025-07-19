// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mental_meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MentalMealAdapter extends TypeAdapter<MentalMeal> {
  @override
  final int typeId = 0;

  @override
  MentalMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MentalMeal(
      food: fields[0] as String,
      mood: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MentalMeal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.food)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MentalMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
