import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'radioPost.freezed.dart';
part 'radioPost.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@freezed
class RadioPost with _$RadioPost {
  const RadioPost._();

  const factory RadioPost({
    required String playerID,
    required String content,
    @TimestampConverter() required DateTime timeOfPost,
    String? id,
  }) = _RadioPost;

  factory RadioPost.fromJson(Map<String, dynamic> json) =>
      _$RadioPostFromJson(json);

  factory RadioPost.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return RadioPost.fromJson(data).copyWith(
          id: doc?.id,
          timeOfPost: (doc?.data()?['timeOfPost'] as Timestamp).toDate());
    } else {
      return RadioPost(
        playerID: '',
        content: '',
        timeOfPost: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
