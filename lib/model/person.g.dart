// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 0;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      fullname: fields[0] as String,
      email: fields[1] as String,
      phone: fields[2] as String,
      address: fields[3] as String,
      degree: fields[4] as String,
      uni: fields[5] as String,
      year: fields[6] as String,
      grade: fields[7] as String,
      company: fields[8] as String,
      role: fields[9] as String,
      experience: fields[10] as String,
      skills: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.fullname)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.degree)
      ..writeByte(5)
      ..write(obj.uni)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.grade)
      ..writeByte(8)
      ..write(obj.company)
      ..writeByte(9)
      ..write(obj.role)
      ..writeByte(10)
      ..write(obj.experience)
      ..writeByte(11)
      ..write(obj.skills);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
