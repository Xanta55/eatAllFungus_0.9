import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'userProfile.freezed.dart';
part 'userProfile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const UserProfile._();
  const factory UserProfile({
    required String name,
    required String description,
    required String currentWorld,
    required int survivedDays,
    String? id,
    required List<dynamic> friends,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromDocument(
      DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return UserProfile.fromJson(data).copyWith(id: doc?.id);
    } else {
      return UserProfile(
        currentWorld: '',
        description: '',
        friends: [],
        name: '',
        survivedDays: 0,
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
