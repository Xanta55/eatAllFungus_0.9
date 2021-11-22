import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/controllers/radioController.dart';
import 'package:eat_all_fungus/views/inGame/radio/radioWidget.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RadioThreadPopup extends StatelessWidget {
  const RadioThreadPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = new TextEditingController();
    final TextEditingController contentController = new TextEditingController();

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
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                    child: Panel(
                      child: Container(
                        color: Colors.grey[colorIntensity],
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              controller: titleController,
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Title',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Panel(
                      child: Container(
                        color: Colors.grey[colorIntensity],
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: TextField(
                            controller: contentController,
                            maxLines: null,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'State your opinion',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                      child: Panel(
                        child: InkWell(
                          onTap: () async {
                            final threadTitle = titleController.text;
                            final threadContent = contentController.text;
                            titleController.clear();
                            contentController.clear();
                            final threadRef = await context
                                .read(radioControllerProvider.notifier)
                                .createNewThread(
                                  threadTitle: threadTitle,
                                  threadContent: threadContent,
                                );
                            context.read(currentThreadProvider).state =
                                threadRef;
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.amber,
                            //width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Broadcast your call for interaction',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
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
