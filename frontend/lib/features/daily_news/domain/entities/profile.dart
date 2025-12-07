import 'package:equatable/equatable.dart';

/// Entity representing a user profile.
class ProfileEntity extends Equatable {
  final String name;
  final String age;
  final String gender;
  final String? imagePath;

  const ProfileEntity({
    this.name = '',
    this.age = '',
    this.gender = '',
    this.imagePath,
  });

  /// Creates a copy of this profile with the given fields replaced with the new values.
  ProfileEntity copyWith({
    String? name,
    String? age,
    String? gender,
    String? imagePath,
  }) {
    return ProfileEntity(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [name, age, gender, imagePath];
}
