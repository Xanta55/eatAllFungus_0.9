import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'forum.freezed.dart';
part 'forum.g.dart';

@freezed
class Forum with _$Forum {
  const Forum._();

  const factory Forum({
    required String title,
    String? id,
  }) = _Forum;

  factory Forum.fromJson(Map<String, dynamic> json) => _$ForumFromJson(json);

  factory Forum.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return Forum.fromJson(data).copyWith(id: doc?.id);
    } else {
      return Forum(
        title: '',
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
