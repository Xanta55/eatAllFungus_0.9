import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/constValues/constConverter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    required String header,
    required String content,
    required String sender,
    String? senderID,
    @TimestampConverter() required DateTime sentAt,
    String? id,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  factory Message.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return Message.fromJson(data).copyWith(id: doc?.id);
    } else {
      return Message(
        header: '',
        content: '',
        sender: '',
        sentAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
