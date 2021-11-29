import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/models/message.dart';
import 'package:eat_all_fungus/providers/streams/messageStream.dart';
import 'package:eat_all_fungus/views/widgets/buttons/profileButton.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/heroWidget.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final messageListState = useProvider(messageStreamProvider);
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Messages',
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: Container(
                color: Colors.grey[colorIntensity],
                child: messageListState != null
                    ? ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Panel(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (context) {
                                    return MessagePopup(
                                        messageListState[index]);
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            messageListState[index].sender,
                                            style: TextStyle(
                                                color: Colors.amber[700],
                                                fontSize: 20.0),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 15.0, 0.0, 15.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              messageListState[index].header,
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    '${messageListState[index].sentAt.hour.toString().padLeft(2, '0')}:${messageListState[index].sentAt.minute.toString().padLeft(2, '0')}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    '${messageListState[index].sentAt.day}-${messageListState[index].sentAt.month}-${messageListState[index].sentAt.year}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Divider(
                              color: Theme.of(context).dividerColor,
                              thickness: 2.0,
                            ),
                          );
                        },
                        itemCount: messageListState.length)
                    : Container(
                        child: Center(
                          child: Text('Loading Messages',
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class MessagePopup extends HookWidget {
  final Message _message;
  const MessagePopup(this._message);
  @override
  Widget build(BuildContext context) {
    final isEditing = useState<bool>(false);
    final textEditController =
        useState<TextEditingController>(TextEditingController());
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          _message.header,
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Panel(
                      child: Container(
                        color: Colors.grey[colorIntensity],
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: Panel(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: isEditing.value
                                        ? TextField(
                                            controller:
                                                textEditController.value,
                                            maxLines: null,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  'State your opinion on this',
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                _message.content,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                          '${_message.sentAt.hour.toString().padLeft(2, '0')}:${_message.sentAt.minute.toString().padLeft(2, '0')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${_message.sentAt.day}-${_message.sentAt.month}-${_message.sentAt.year}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _message.senderID != null
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            children: [
                              buildProfileButton(context,
                                  profileID: _message.senderID),
                              Expanded(
                                child: Container(
                                  child: isEditing.value
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read(messageStreamProvider
                                                    .notifier)
                                                .sendMessage(
                                                    header:
                                                        'RE: ${_message.header}',
                                                    receiverID:
                                                        _message.senderID!,
                                                    content: textEditController
                                                        .value.text);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Send'),
                                        )
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            textEditController.value.text =
                                                '\n\n####################\n\nSender: ${_message.sender}\n\nTopic: ${_message.header}\n\nContent:\n${_message.content}';
                                            textEditController.value.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(offset: 0));
                                            isEditing.value = true;
                                          },
                                          child: Text('Answer'),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SendMessagePopup extends HookWidget {
  final String receiverID;

  const SendMessagePopup(this.receiverID);

  @override
  Widget build(BuildContext context) {
    final textEditController = TextEditingController();
    final headerEditController = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Panel(
                          child: Container(
                            color: Colors.grey[colorIntensity],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: headerEditController,
                                maxLines: 1,
                                autofocus: true,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Topic',
                                ),
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Panel(
                      child: Container(
                        color: Colors.grey[colorIntensity],
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: Panel(
                                  child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextField(
                                        controller: textEditController,
                                        maxLines: null,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              'State your opinion on this',
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read(messageStreamProvider.notifier)
                              .sendMessage(
                                  header: headerEditController.text,
                                  receiverID: receiverID,
                                  content: textEditController.text);
                          Navigator.pop(context);
                        },
                        child: Text('Send'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
