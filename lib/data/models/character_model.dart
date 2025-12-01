import 'package:hive/hive.dart';
import '../../domain/entities/character.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends Character {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String status;

  @HiveField(3)
  @override
  final String species;

  @HiveField(4)
  @override
  final String type;

  @HiveField(5)
  @override
  final String gender;

  @HiveField(6)
  @override
  final String image;

  @HiveField(7)
  @override
  final String locationName;

  @HiveField(8)
  @override
  final String originName;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.locationName,
    required this.originName,
  }) : super(
          id: id,
          name: name,
          status: status,
          species: species,
          type: type,
          gender: gender,
          image: image,
          locationName: locationName,
          originName: originName,
        );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String,
      image: json['image'] as String,
      locationName: json['location']?['name'] as String? ?? 'Unknown',
      originName: json['origin']?['name'] as String? ?? 'Unknown',
    );
  }

  factory CharacterModel.fromEntity(Character character) {
    return CharacterModel(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      type: character.type,
      gender: character.gender,
      image: character.image,
      locationName: character.locationName,
      originName: character.originName,
    );
  }

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      image: image,
      locationName: locationName,
      originName: originName,
    );
  }
}

