// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charactor_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharactorTypeAdapter extends TypeAdapter<CharactorType> {
  @override
  final int typeId = 1;

  @override
  CharactorType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CharactorType.fire;
      // case 1:
      //   return SpaceshipType.dusky;
      // case 2:
      //   return SpaceshipType.condor;
      // case 3:
      //   return SpaceshipType.cXC;
      // case 4:
      //   return SpaceshipType.raptor;
      // case 5:
      //   return SpaceshipType.raptorX;
      // case 6:
      //   return SpaceshipType.albatross;
      // case 7:
      //   return SpaceshipType.dK809;
      default:
        return CharactorType.fire;
    }
  }

  @override
  void write(BinaryWriter writer, CharactorType obj) {
    switch (obj) {
      case CharactorType.fire:
        writer.writeByte(0);
        break;
      // case SpaceshipType.dusky:
      //   writer.writeByte(1);
      //   break;
      // case SpaceshipType.condor:
      //   writer.writeByte(2);
      //   break;
      // case SpaceshipType.cXC:
      //   writer.writeByte(3);
      //   break;
      // case SpaceshipType.raptor:
      //   writer.writeByte(4);
      //   break;
      // case SpaceshipType.raptorX:
      //   writer.writeByte(5);
      //   break;
      // case SpaceshipType.albatross:
      //   writer.writeByte(6);
      //   break;
      // case SpaceshipType.dK809:
      //   writer.writeByte(7);
      //   break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharactorTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
