// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignModelAdapter extends TypeAdapter<AssignModel> {
  @override
  final int typeId = 0;

  @override
  AssignModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignModel(
      title: fields[0] as String,
      date: fields[2] as String,
      desc: fields[1] as String?,
      subject: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AssignModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.desc)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.subject);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}