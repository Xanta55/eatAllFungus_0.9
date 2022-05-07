import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/constValues/constConverter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'thread.freezed.dart';
part 'thread.g.dart';

@freezed
class Thread with _$Thread {
  const Thread._();

  const factory Thread({
    required String title,
    @TimestampConverter() required DateTime lastUpdate,
    String? id,
  }) = _Thread;

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);

  factory Thread.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return Thread.fromJson(data).copyWith(id: doc?.id);
    } else {
      return Thread(title: '', lastUpdate: DateTime.now());
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
