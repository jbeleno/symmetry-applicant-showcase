import 'package:equatable/equatable.dart';

/// Represents the state of the user profile.
/// Contains user details like name, age, gender, and avatar path.
class ProfileState extends Equatable {
  final String name;
  final String age;
  final String gender;
  final String? imagePath;

  const ProfileState({
    this.name = '',
    this.age = '',
    this.gender = '',
    this.imagePath,
  });

  ProfileState copyWith({
    String? name,
    String? age,
    String? gender,
    String? imagePath,
  }) {
    return ProfileState(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [name, age, gender, imagePath];
}
