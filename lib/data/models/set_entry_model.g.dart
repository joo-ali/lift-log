// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetEntryModelAdapter extends TypeAdapter<SetEntryModel> {
  @override
  final int typeId = 0;

  @override
  SetEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetEntryModel(
      weight: fields[0] as double,
      reps: fields[1] as int,
      isDone: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SetEntryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

