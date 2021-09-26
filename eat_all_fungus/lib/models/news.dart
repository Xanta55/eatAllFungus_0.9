import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'news.freezed.dart';
part 'news.g.dart';

@freezed
class News with _$News {
  const News._();
  const factory News({required String news, String? id}) = _News;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  factory News.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return News.fromJson(data).copyWith(id: doc?.id);
    } else {
      return News(news: 'Probably some news right here...');
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
