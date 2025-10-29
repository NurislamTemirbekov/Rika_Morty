import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final String image;

  @HiveField(7)
  final String locationName;

  @HiveField(8)
  final String originName;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.locationName,
    required this.originName,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
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

  @override
  List<Object?> get props => [id, name, status, species, type, gender, image, locationName, originName];
}

