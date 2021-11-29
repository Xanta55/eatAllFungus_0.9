import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/message.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/streams/profileStream.dart';
import 'package:eat_all_fungus/services/profileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final messageStreamProvider =
    StateNotifierProvider<MessageStreamer, List<Message>?>((ref) {
  final profile = ref.watch(profileStreamProvider);
  return MessageStreamer(ref.read, profile);
});

class MessageStreamer extends StateNotifier<List<Message>?> {
  final Reader _read;
  final UserProfile? _profile;

  StreamSubscription<List<Message>?>? _messageSubscription;

  MessageStreamer(this._read, this._profile) : super(null) {
    if (_profile != null) {
      _messageSubscription?.cancel();
      getMessageStream();
    }
  }

  Future<void> getMessageStream() async {
    try {
      _messageSubscription = _read(userProfileRepository)
          .getMessageStream(id: _profile!.id!)
          .listen((messages) {
        state = messages;
      });
    } on CustomException catch (error) {
      print('MessageStream - ${error.message}');
      state = null;
    }
  }

  Future<void> sendMessage({
    required String header,
    required String receiverID,
    required String content,
  }) async {
    try {
      await _read(userProfileRepository).sendMessage(
          receiverID: receiverID,
          message: Message(
            header: header,
            content: content,
            sender: _profile!.name,
            senderID: _profile!.id!,
            sentAt: DateTime.now(),
          ));
    } on CustomException catch (error) {
      print('MessageStream - ${error.message}');
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}
